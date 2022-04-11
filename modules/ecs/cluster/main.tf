locals {
  current_account_id     = data.aws_caller_identity.current.account_id
  bash_friendly_app_name = replace(var.app_name, "-", "_")
}

data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "nerves-hub-${var.environment_name}"

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# This is created for all load balancers in the cluster, so we can whitelist
# inbound from these load balancers on the instance security group
resource "aws_security_group" "lb_security_group" {
  name        = "${aws_ecs_cluster.ecs_cluster.name}-load-balancer"
  description = "${aws_ecs_cluster.ecs_cluster.name} load balancers"
  vpc_id      = var.aws_vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80

    cidr_blocks      = var.allow_list_ipv4
    ipv6_cidr_blocks = var.allow_list_ipv6
  }

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443

    cidr_blocks      = var.allow_list_ipv4
    ipv6_cidr_blocks = var.allow_list_ipv6
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = merge(var.tags, {
    Name = "${aws_ecs_cluster.ecs_cluster.name}-load-balancer"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = aws_ecs_cluster.ecs_cluster.name
  retention_in_days = terraform.workspace == "staging" ? 1 : var.log_retention
}

module "firelens_log_config" {
  source              = "../../firelens_log_config"
  app_name            = var.app_name
  datadog_key_ssm_arn = aws_ssm_parameter.datadog_key.arn
  environment_name    = var.environment_name
  task_name           = local.bash_friendly_app_name
  datadog_image       = var.datadog_image
  region              = var.region
  ssm_prefix          = var.ssm_prefix

  tags                = var.tags
}