resource "aws_ssm_parameter" "datadog_key" {
  name   = "/${var.ssm_prefix}/${var.environment_name}/DATADOG_KEY"
  type   = "SecureString"
  value  = "ChangeMeInTheWebConsole"
  key_id = var.kms_key_id
  overwrite = true

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}