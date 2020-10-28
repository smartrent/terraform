variable "account_id" {}
variable "region" {}
variable "kms_key" {}
variable "vpc" {}
variable "task_security_group_id" {}
variable "public_dns_zone" {}
variable "domain" {}
variable "db" {}
variable "log_group" {}
variable "docker_image" {}
variable "erl_cookie" {}
variable "app_bucket" {}
variable "log_bucket" {}
variable "ca_bucket" {}
variable "ca_host" {}
variable "cluster" {}
variable "secret_key_base" {}
variable "smtp_username" {}
variable "smtp_password" {}
variable "service_count" {}
variable "task_execution_role" {}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}