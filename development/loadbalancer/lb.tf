variable "lb_name" {} 
variable "lb_type" {}
variable "is_internal" {}
variable "sg_enable_ssh_https" {}
variable "subnet_ids" {}
variable "lb_listner_port" {}
variable "lb_listner_protocol" {}
variable "lb_listner_default_action" {}
variable "lb_target_group_arn" {}
# variable "ec2_sg_enable_for_python_api" {}

output "aws_lb_dns_name" {
    value = aws_lb.dev_proj_1_lb.dns_name
  
}






















resource "aws_lb" "dev_proj_1_lb" {
    name = var.lb_name
    internal = var.is_internal
    load_balancer_type = var.lb_type
    security_groups = [var.sg_enable_ssh_https]
    subnets = var.subnet_ids

    enable_deletion_protection = false

    tags = {
      Name = "lb_jenk"
    }
  
}

resource "aws_lb_listener" "dev_proj_1_ln_listner" {
    load_balancer_arn = aws_lb.dev_proj_1_lb.arn
    port = var.lb_listner_port
    protocol = var.lb_listner_protocol

    default_action {
      type =  var.lb_listner_default_action
      target_group_arn = var.lb_target_group_arn
    }
  
}