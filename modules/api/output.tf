output "lb_zone_id" {
  value = var.nlb ? element(aws_lb.api_lb.*.zone_id, 0) : null
}

output "lb_dns_name" {
  value = var.nlb ? element(aws_lb.api_lb.*.dns_name, 0) : null
}

output "alb_zone_id" {
  value = var.alb ? element(aws_lb.api_alb.*.zone_id, 0) : null
}

output "alb_dns_name" {
  value = var.alb ? element(aws_lb.api_alb.*.dns_name, 0) : null
}

output "alb_security_group_id" {
  value = var.alb ? element(aws_security_group.port80_lb_security_group.id, 0) : null
}

output "nlb_security_group_id" {
  value = var.nlb ? element(aws_security_group.port443_lb_security_group.id, 0) : null
}
