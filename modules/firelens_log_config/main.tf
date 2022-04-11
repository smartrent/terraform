# This is just a module to provide a template for creating a log configuration for an ECS task definition.

locals {
  tld = var.region == "eu-central-1" ? "eu" : "com"

  ecs_shared_env_vars = <<EOF
        { "name" : "ENVIRONMENT", "value" : "${var.environment_name}" },
        { "name" : "APP_NAME", "value" : "${var.app_name}" }
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

  ecs_shared_env_vars = <<EOF
        { "name" : "ENVIRONMENT", "value" : "${var.environment_name}" },
        { "name" : "APP_NAME", "value" : "${var.app_name}" }
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

  log_configuration = <<EOF
"mountPoints": [],
"volumesFrom": [],
"logConfiguration": {
      "logDriver": "awsfirelens",
      "options": {
        "Name": "datadog",
        "compress": "gzip",
        "Host": "http-intake.logs.datadoghq.${local.tld}",
        "dd_service": "${var.app_name}",
        "dd_source": "${var.dd_source}",
        "dd_message_key": "log",
        "dd_tags": "env:${var.environment_name},application:${var.app_name}-${var.environment_name},version:${var.datadog_image},task:${var.task_name}",
        "TLS": "on",
        "provider": "ecs"
      },
      "secretOptions": [
        {
          "name": "apikey",
          "valueFrom": "${var.datadog_key_ssm_arn}"
        }
      ]
    },
    "dockerLabels": {
      "com.datadoghq.tags.env": "${var.environment_name}",
      "com.datadoghq.tags.service": "${var.app_name}",
      "com.datadoghq.tags.version": "${var.datadog_image}"
    }
EOF
}