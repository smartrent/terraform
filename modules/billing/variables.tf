variable "account_id" {}
variable "region" {}
variable "domain" {}
variable "vpc" {}
variable "cluster" {}
variable "db" {}
variable "kms_key" {}
variable "ca_bucket" {}
variable "app_bucket" {}
variable "docker_image" {}
variable "log_group" {}
variable "service_count" {}
variable "task_execution_role" {}
variable "erl_cookie" {}
variable "web_security_group" {}
variable "local_dns_namespace" {}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}