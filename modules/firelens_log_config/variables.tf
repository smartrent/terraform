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

variable "region" {
  type        = string
  description = "The AWS Region"
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

variable "datadog_image_tag" {
  description = "Datadog container image tag"
  type = string
}

variable "kms_key_id" {
  description = "KMS Key to access SSM Parameters"
  type = string
}

variable "datadog_key" {
  description = "Datadog Key"
  type = string
}