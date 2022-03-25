variable "datadog_key_ssm_arn" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "task_name" {
  type = string
}

variable "datadog_image" {
  type = string
}

variable "dd_source" {
  type    = string
  default = "elixir"
}

variable "aws_region" {
  type        = string
  description = "The AWS Region"
}

output "log_configuration" {
  value = local.log_configuration
}

variable "ssm_prefix" {
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}