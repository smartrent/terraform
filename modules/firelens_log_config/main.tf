# This is just a module to provide a template for creating a log configuration for an ECS task definition.

locals {
  tld = var.region == "eu-central-1" ? "eu" : "com"

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
        "dd_tags": "env:${var.environment_name},application:${var.app_name}-${var.environment_name},version:${var.docker_image_tag},task:${var.task_name}",
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
      "com.datadoghq.tags.version": "${var.docker_image_tag}"
    }
EOF
}