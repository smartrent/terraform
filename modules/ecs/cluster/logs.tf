module "log_config" {
  source              = "git@github.com:smartrent/terraform-infrastructure.git//modules/firelens_log_config?ref=5c3f0a306198a88137d07930586f5d1177bdaf46"
  app_name            = var.app_name
  datadog_key_ssm_arn = aws_ssm_parameter.datadog_key.arn
  environment_name    = var.profile
  task_name           = local.web_task_name
}