variable "account_id" {}
variable "region" {}
variable "kms_key" {}
variable "vpc" {}
variable "task_security_group_id" {}
variable "host_name" {}
variable "db" {}
variable "docker_image" {}
variable "erl_cookie" {}
variable "app_bucket" {}
variable "log_bucket" {}
variable "ca_bucket" {}
variable "cluster" {}
variable "secret_key_base" {}
variable "smtp_username" {}
variable "smtp_password" {}
variable "service_count" {}
variable "task_execution_role" {}

variable "cpu" {
  type        = string
  description = "CPU resource allocation"
  default     = "256"
}
variable "memory" {
  type        = string
  description = "Memory resource allocation"
  default     = "512"
}

variable "from_email" {
  default = "no-reply@nerves-hub.org"
}

variable "access_logs" {
  default = false
}

variable "access_logs_bucket" {
  default = ""
}

variable "access_logs_prefix" {
  default = "nerves-hub-device-nlb"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}

variable "datadog_image" {
  description = "Datadog container image"
  type        = string
}

variable "docker_image_tag" {
  description = "Docker Image tag for Device Application"
  type        = string
}

variable "datadog_key_arn" {
  description = "Datadog Key"
  type        = string
}

variable "device_db_pool_size" {
  description = "Database Pool Size for Device Tasks"
  type        = number
  default     = 5
}
