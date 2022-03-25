# This is just a module to provide a template for creating a log configuration for an ECS task definition.

module "log_config" {
  source              = "../../../modules/firelens_log_config"
  app_name            = var.app_name
  datadog_key_ssm_arn = aws_ssm_parameter.datadog_key.arn
  environment_name    = var.profile
  task_name           = local.web_task_name
  datadog_image       = var.datadog_image
  aws_region          = var.aws_region
}

locals {
  tld = var.aws_region == "eu-central-1" ? "eu" : "com"

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