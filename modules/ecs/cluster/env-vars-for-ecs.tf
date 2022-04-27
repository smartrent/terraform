locals {

  ecs_shared_ssm_secrets = <<EOF
        {
            "name": "DATABASE_URL",
            "valueFrom": "${aws_ssm_parameter.database_url.arn}"
        },
        {
            "name": "ERL_COOKIE",
            "valueFrom": "${aws_ssm_parameter.erl_cookie.arn}"
        },
        {
            "name": "APP_NAME",
            "valueFrom": "${aws_ssm_parameter.app_name.arn}"
        },
        {
            "name": "S3_BUCKET_NAME",
            "valueFrom": "${aws_ssm_parameter.s3_bucket_name.arn}"
        }
EOF

  ecs_daw_shared_ssm_secrets = <<EOF
        {
          "name": "CLUSTER_NAME",
          "valueFrom": "${aws_ssm_parameter.cluster_name.arn}"
        },
        {
          "name": "AWS_REGION",
          "valueFrom": "${aws_ssm_parameter.aws_region.arn}"
        },
        {
          "name": "SES_PORT",
          "valueFrom": "${aws_ssm_parameter.ses_port.arn}"
        },
        {
          "name": "SES_SERVER",
          "valueFrom": "${aws_ssm_parameter.ses_server.arn}"
        },
        {
          "name": "SES_FROM_EMAIL",
          "valueFrom": "${aws_ssm_parameter.ses_from_email.arn}"
        },
        {
          "name": "SMTP_USERNAME",
          "valueFrom": "${aws_ssm_parameter.smtp_username.arn}"
        },
        {
          "name": "SMTP_PASSWORD",
          "valueFrom": "${aws_ssm_parameter.smtp_password.arn}"
        },
        {
            "name": "SECRET_KEY_BASE",
            "valueFrom": "${aws_ssm_parameter.secret_key_base.arn}"
        },
        {
            "name": "S3_SSL_BUCKET",
            "valueFrom": "${aws_ssm_parameter.s3_ssl_bucket.arn}"
        },
        {
            "name": "S3_LOG_BUCKET",
            "valueFrom": "${aws_ssm_parameter.s3_log_bucket.arn}"
        }
EOF
  ecs_shared_env_vars = <<EOF
        { "name" : "ENVIRONMENT", "value" : "${var.environment_name}" },
        { "name" : "APP_NAME", "value" : "${local.bash_friendly_app_name}" }
EOF

  fire_lens_container = <<EOF
  {
    "essential": true,
<<<<<<< HEAD
    "image": "906394416424.dkr.ecr.${var.region}.amazonaws.com/aws-for-fluent-bit:stable",
=======
    "image": "906394416424.dkr.ecr.${var.aws_region}.amazonaws.com/aws-for-fluent-bit:stable",
>>>>>>> 5c4abef (Update modules/ecs/cluster/env-vars-for-ecs.tf)
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
}