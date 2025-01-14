variable "name" {

}

variable "identifier" {

}

variable "username" {

}
variable "password" {

}

variable "vpc_id" {

}

variable "kms_key" {

}

variable "allocated_storage" {
  type = number
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "storage_iops" {
  type    = number
  default = null
}

variable "storage_throughput" {
  type    = number
  default = null
}

variable "instance_class" {
  description = "The Instance class of the Postgres database server"
}
variable "engine_version" {
  description = "The Engine version of the Postgres database server"
}

variable "subnet_group" {
  description = "DB subnet group"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default = {
    terraform = true
  }
}

variable "security_groups" {
  default = [""]
}

variable "cidr_blocks" {
  default = [""]
}

variable "backup_retention_period" {
  default = 1
}

variable "performance_insights" {
  default = false
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "allow_major_version_upgrade" {
  type    = bool
  default = false
}

variable "deletion_protection" {
  default = false
}

variable "multi_az" {
  default = false
}

variable "copy_tags_to_snapshot" {
  default = false
}

variable "cloudwatch_log_exports" {
  default = []
}

variable "family" {
  default = "postgres11"
}

variable "parameters" {
  default = []
}

variable "options" {
  default = []
}

variable "major_engine_version" {
  default = 11
}

variable "timeouts" {
  description = "Define maximum timeout for deletion of `aws_db_option_group` resource"
  type        = map(string)
  default = {
    delete = "15m"
  }
}

variable "monitoring_role_arn" {
  type    = string
  default = null
}

variable "monitoring_interval" {
  type    = number
  default = 0
}

variable "maintenance_window" {
  type    = string
  default = null
}
