resource "aws_ssm_parameter" "datadog_key" {
  name   = "/${var.ssm_prefix}/${var.environment_name}/DATADOG_KEY"
  type   = "SecureString"
  value  = "ChangeMeInTheWebConsole"
  key_id = aws_kms_key.for_ssm_params.key_id

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_kms_key" "for_ssm_params" {
  description = "KMS key for ${var.app_name} ${var.environment_name} Secrets"

  tags = var.tags
}