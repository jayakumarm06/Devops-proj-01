variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}  
variable "sg_enable_ssh_https" {}
variable "ec2_sg_name_for_python_api" {}
variable "enable_public_ip_address" {}
variable "ec2_tag_name" {}
variable "user_data_python_api" {}
variable "public_key" {}



output "ec2_python_instance_id" {
    value = aws_instance.dev_proj_1_ec2.id
  
}










resource "aws_instance" "dev_proj_1_ec2" {

    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.sg_enable_ssh_https,var.ec2_sg_name_for_python_api]
    associate_public_ip_address = var.enable_public_ip_address

    user_data = var.user_data_python_api

    metadata_options {
      http_endpoint = "enabled" # Enable the IMDSv2 endpoint
      http_tokens = "required" # Require the use of IMDSv2 tokens
    }

    tags = {
      Name  =  var.ec2_tag_name
    }
  
}

