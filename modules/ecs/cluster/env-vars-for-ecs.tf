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
            "name": "SECRET_KEY_BASE",
            "valueFrom": "${aws_ssm_parameter.secret_key_base.arn}"
        }
EOF

  ecs_shared_env_vars = <<EOF
        { "name" : "MIX_ENV", "value" : "${var.profile}" },
        { "name" : "MAX_ATTEMPTS_BEFORE_MANUAL_VERIFICATION", "value" : "${var.max_attempts_before_manual_verification}" },
        { "name" : "APP_NAME", "value" : "${local.bash_friendly_app_name}" },
        { "name" : "HOST", "value" : "${var.host_name}" },
        { "name" : "PORT", "value" : "8080" },
        { "name" : "LOGGER_LEVEL", "value" : "${var.log_level}" },
        { "name" : "S3_BUCKET_NAME", "value" : "${var.bucket_name}" }
EOF

  fire_lens_container = <<EOF
  {
    "essential": true,
    "image": "906394416424.dkr.ecr.${var.aws_region}.amazonaws.com/aws-for-fluent-bit:latest",
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