locals {

  ecs_shared_env_vars = <<EOF
        { "name" : "ENVIRONMENT", "value" : "${var.environment}" },
        { "name" : "APP_NAME", "value" : "${local.bash_friendly_app_name}" }
EOF

  fire_lens_container = <<EOF
  {
    "essential": true,
    "image": "906394416424.dkr.ecr.${var.aws_region}.amazonaws.com/aws-for-fluent-bit:stable",
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