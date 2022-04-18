locals {
  app_name = "nerves_hub_api"
  ssm_prefix = "nerves_hub_api"

  ecs_shared_env_vars = <<EOF
    { "name" : "ENVIRONMENT", "value" : "${var.environment_name}" },
    { "name" : "APP_NAME", "value" : "${local.app_name}" }
EOF

  fire_lens_container = <<EOF
  {
    "essential": true,
    "image": "906394416424.dkr.ecr.${var.region}.amazonaws.com/aws-for-fluent-bit:stable",
    "name": "log_router",
    "cpu": 0,
    "user": "0",
    "environment": [],
    "volumesFrom": [],
    "portMappings": [],
    "mountPoints": [],
    "firelensConfiguration": {
      "type": "fluentbit",
      "options": {
        "enable-ecs-log-metadata": "true"
      }
    },
    "memoryReservation": 50
  }
EOF

 datadog_ecs_agent_task_def = <<EOF
{
  "name": "datadog-agent",
  "image": "${var.datadog_image}",
  "essential": false,
  "memoryReservation": 256,
  "cpu": 10,
  "mountPoints": [],
  "volumesFrom": [],
  "portMappings": [
    {
      "containerPort": 8125,
      "hostPort": 8125,
      "protocol": "udp"
    },
    {
      "containerPort": 8126,
      "hostPort": 8126,
      "protocol": "tcp"
    }
  ],
  "environment": [
    {
      "name": "ECS_FARGATE",
      "value": "true"
    },
    {
      "name": "DD_LOG_LEVEL",
      "value": "warn"
    },
    {
      "name": "DD_APM_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_APM_NON_LOCAL_TRAFFIC",
      "value": "true"
    },
    {
      "name": "DD_SYSTEM_PROBE_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_PROCESS_AGENT_ENABLED",
      "value": "true"
    },
    {
      "name": "DD_HEALTH_PORT",
      "value": "5555"
    },
    {
      "name": "DD_APM_RECEIVER_PORT",
      "value": "8126"
    },
    {
      "name": "DD_DOGSTATSD_NON_LOCAL_TRAFFIC",
      "value": "true"
    },
    {
      "name": "DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL",
      "value": "true"
    },
    {
      "name": "DD_DOGSTATSD_PORT",
      "value": "8125"
    },
    {
      "name": "DD_DOCKER_LABELS_AS_TAGS",
      "value": "${replace(jsonencode(var.tags), "\"", "\\\"")}"
    }
  ],
  "secrets": [
    {
      "name": "DD_API_KEY",
      "valueFrom": "${aws_ssm_parameter.datadog_key.arn}"
    }
  ],
  ${module.firelens_log_config.log_configuration}
}
EOF
}

resource "random_integer" "target_group_id" {
  min = 1
  max = 999
}

# Load Balancer
resource "aws_lb_target_group" "api_lb_tg" {
  name                 = "nerves-hub-${terraform.workspace}-api-tg-${random_integer.target_group_id.result}"
  port                 = 443
  protocol             = "TCP"
  target_type          = "ip"
  vpc_id               = var.vpc.vpc_id
  deregistration_delay = 120

  health_check {
    protocol = "TCP"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_lb" "api_lb" {
  name               = "nerves-hub-${terraform.workspace}-api-lb"
  internal           = var.internal_lb
  load_balancer_type = "network"
  subnets            = var.vpc.public_subnets

  access_logs {
    enabled = var.access_logs
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
  }

  tags = var.tags
}

resource "aws_lb_listener" "api_lb_listener" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_lb_tg.arn
  }
}

# SSM
resource "aws_ssm_parameter" "nerves_hub_api_ssm_secret_db_url" {
  name      = "/${local.app_name}/${terraform.workspace}/DATABASE_URL"
  type      = "SecureString"
  value     = "postgres://${var.db.username}:${var.db.password}@${var.db.endpoint}/${var.db.name}"
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_secret_erl_cookie" {
  name      = "/${local.app_name}/${terraform.workspace}/ERL_COOKIE"
  type      = "SecureString"
  value     = var.erl_cookie
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_s3_ssl_bucket" {
  name      = "/${local.app_name}/${terraform.workspace}/S3_SSL_BUCKET"
  type      = "String"
  value     = var.ca_bucket
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_s3_log_bucket_name" {
  name      = "/${local.app_name}/${terraform.workspace}/S3_LOG_BUCKET_NAME"
  type      = "String"
  value     = var.log_bucket
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_app_name" {
  name      = "/${local.app_name}/${terraform.workspace}/APP_NAME"
  type      = "String"
  value     = local.app_name
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_cluster" {
  name      = "/${local.app_name}/${terraform.workspace}/CLUSTER"
  type      = "String"
  value     = var.cluster.name
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_aws_region" {
  name      = "/${local.app_name}/${terraform.workspace}/AWS_REGION"
  type      = "String"
  value     = var.region
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_port" {
  name      = "/${local.app_name}/${terraform.workspace}/PORT"
  type      = "String"
  value     = 80
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_host" {
  name      = "/${local.app_name}/${terraform.workspace}/HOST"
  type      = "String"
  value     = var.host_name
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_ca_host" {
  name      = "/${local.app_name}/${terraform.workspace}/CA_HOST"
  type      = "String"
  value     = var.ca_host
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_s3_bucket_name" {
  name      = "/${local.app_name}/${terraform.workspace}/S3_BUCKET_NAME"
  type      = "String"
  value     = var.app_bucket
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_secret_secret_key_base" {
  name      = "/${local.app_name}/${terraform.workspace}/SECRET_KEY_BASE"
  type      = "SecureString"
  value     = var.secret_key_base
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_ses_port" {
  name      = "/${local.app_name}/${terraform.workspace}/SES_PORT"
  type      = "String"
  value     = "587"
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_ses_server" {
  name      = "/${local.app_name}/${terraform.workspace}/SES_SERVER"
  type      = "String"
  value     = "email-smtp.${var.region}.amazonaws.com"
  overwrite = true
  tags      = var.tags
}

resource "aws_ssm_parameter" "nerves_hub_www_ses_from_email" {
  name      = "/${local.app_name}/${terraform.workspace}/FROM_EMAIL"
  type      = "SecureString"
  value     = var.from_email
  overwrite = true
  tags      = var.tags
}

# Set lifecycle parameter for SMTP creds to avoid sensitive info in tfvars
# To accommodate for AWS SES Access Keys generated
resource "aws_ssm_parameter" "nerves_hub_api_ssm_smtp_username" {
  name      = "/${local.app_name}/${terraform.workspace}/SMTP_USERNAME"
  type      = "SecureString"
  value     = var.smtp_password
  overwrite = true
  tags      = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "nerves_hub_api_ssm_secret_smtp_password" {
  name      = "/${local.app_name}/${terraform.workspace}/SMTP_PASSWORD"
  type      = "SecureString"
  value     = var.smtp_username
  overwrite = true
  tags      = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

# Roles
## Task role
resource "aws_iam_role" "api_task_role" {
  name = "nerves-hub-${terraform.workspace}-api-role"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Sid": "",
       "Effect": "Allow",
       "Principal": {
         "Service": "ecs-tasks.amazonaws.com"
       },
       "Action": "sts:AssumeRole"
     }
  ]
}
EOF
  tags               = var.tags
}

data "aws_iam_policy_document" "api_iam_policy" {
  statement {
    sid = "1"

    actions = [
      "ssm:DescribeParameters",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${local.app_name}/${terraform.workspace}*"
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.app_bucket}",
      "arn:aws:s3:::${var.ca_bucket}"
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
    ]

    resources = [
      "arn:aws:s3:::${var.app_bucket}/*"
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent"
    ]

    resources = [
      "arn:aws:s3:::${var.ca_bucket}/ssl/*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      var.kms_key.arn,
    ]
  }

  statement {
    actions = [
      "ecs:DeregisterContainerInstance",
      "ecs:RegisterContainerInstance",
      "ecs:StartTask",
      "ecs:Submit*",
    ]

    resources = [
      aws_ecs_service.api_ecs_service.cluster,
      "arn:aws:ecs:${var.region}:${var.account_id}:task-definition/nerves-hub-${terraform.workspace}-api:*",
    ]
  }

  statement {
    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTasks",
      "ecs:DiscoverPollEndpoint",
      "ecs:ListServices",
      "ecs:ListTasks",
      "ecs:Poll",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "api_task_policy" {
  name   = "nerves-hub-${terraform.workspace}-api-task-policy"
  policy = data.aws_iam_policy_document.api_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "api_role_policy_attach" {
  role       = aws_iam_role.api_task_role.name
  policy_arn = aws_iam_policy.api_task_policy.arn
}

# ECS
resource "aws_ecs_task_definition" "api_task_definition" {
  family             = "nerves-hub-${terraform.workspace}-api"
  task_role_arn      = aws_iam_role.api_task_role.arn
  execution_role_arn = var.task_execution_role.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  tags = var.tags

  container_definitions = <<DEFINITION
   [
     ${local.fire_lens_container},
     {
       "portMappings": [
         {
           "hostPort": 443,
           "protocol": "tcp",
           "containerPort": 443
         },
         {
           "hostPort": 4369,
           "protocol": "tcp",
           "containerPort": 4369
         }
       ],
       "networkMode": "awsvpc",
       "image": "${var.docker_image}",
       "essential": true,
       "privileged": false,
       "name": "${local.app_name}",
       "environment": [
         ${local.ecs_shared_env_vars}
       ],
       "volumesFrom": [],
       "mountPoints": [],
       "logConfiguration": {
         "logDriver": "awsfirelens",
         "options": {
            "Name": "datadog",
            "compress": "gzip",
            "Host": "http-intake.logs.datadoghq.com",
            "dd_service": "${local.app_name}",
            "dd_source": "elixir",
            "dd_message_key": "log",
            "dd_tags": "env:${var.environment_name},application:${local.app_name}-${var.environment_name},version:${var.docker_image}",
            "TLS": "on",
            "provider": "ecs"
          },
          "secretOptions": [
            {
              "name": "apikey",
              "valueFrom": "${aws_ssm_parameter.datadog_key.arn}"
            }
          ]
       }
     },
     ${local.datadog_ecs_agent_task_def}
   ]

DEFINITION

}

resource "aws_ssm_parameter" "datadog_key" {
  name   = "/${local.ssm_prefix}/DATADOG_KEY"
  type   = "SecureString"
  value  = "ChangeMeInTheWebConsole"
  key_id = aws_kms_key.for_ssm_params.key_id

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_kms_key" "for_ssm_params" {
  description = "KMS key for ${local.app_name} ${var.environment_name} Secrets"

  tags = var.tags
}

module "firelens_log_config" {
  source              = "../firelens_log_config"
  app_name            = local.app_name
  datadog_key_ssm_arn = aws_ssm_parameter.datadog_key.arn
  environment_name    = var.environment_name
  task_name           = local.app_name
  datadog_image       = var.datadog_image
  region          = var.region
  ssm_prefix          = local.ssm_prefix

  tags                = var.tags
}

resource "aws_ecs_service" "api_ecs_service" {
  name    = "nerves-hub-api"
  cluster = var.cluster.arn

  # this needs to be toggled on to update anything in the task besides container (e.g. CPU, memory, etc)
  # task_definition = "${aws_ecs_task_definition.api_task_definition.family}:${max("${aws_ecs_task_definition.api_task_definition.revision}", "${data.aws_ecs_task_definition.api_task_definition.revision}")}"
  # task_definition = "${aws_ecs_task_definition.api_task_definition.family}:${aws_ecs_task_definition.api_task_definition.revision}"

  task_definition = aws_ecs_task_definition.api_task_definition.arn
  desired_count   = var.service_count
  propagate_tags  = "TASK_DEFINITION"

  deployment_minimum_healthy_percent = "100"
  deployment_maximum_percent         = "200"
  launch_type                        = "FARGATE"

  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = aws_lb_target_group.api_lb_tg.arn
    container_name   = local.app_name
    container_port   = 443
  }

  network_configuration {
    security_groups = [var.task_security_group_id]
    subnets         = var.vpc.private_subnets
  }

  # After the first setup, we want to ignore this so deploys aren't reverted
  lifecycle {
    ignore_changes = [task_definition] # create_before_destroy = true
  }

  tags = var.tags

  depends_on = [
    aws_iam_role.api_task_role,
    aws_lb_listener.api_lb_listener
  ]
}
