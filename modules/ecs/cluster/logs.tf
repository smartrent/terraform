module "log_config" {
  source              = "../../../modules/firelens_log_config"
  app_name            = var.app_name
  datadog_key_ssm_arn = aws_ssm_parameter.datadog_key.arn
  environment_name    = var.profile
  task_name           = local.web_task_name
}