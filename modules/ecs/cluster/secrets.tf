resource "aws_ssm_parameter" "datadog_key" {
  name   = "${local.ssm_prefix}DATADOG_KEY"
  type   = "SecureString"
  value  = "ChangeMeInTheWebConsole"
  key_id = aws_kms_key.for_ssm_params.key_id

  tags = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}