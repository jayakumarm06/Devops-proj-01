variable "ec2_sg_name" {}
variable "ec2_sg_name_for_python_api" {}
variable "vpc_id" {}
variable "rds_mysql_sg_name" {}
variable "public_subnet_cidr_block" {}








output "sg_ec2_sg_ssh_http_id" {
    value = aws_security_group.ec2_sg_ssh_http.id
  
}

output "sg_ec2_sg_python_api_id" {
    value = aws_security_group.sg_python_api.id
  
}


output "sg_rds_mysql_sg_id" {
  value = aws_security_group.rds_mysql_sg.id
}







resource "aws_security_group" "ec2_sg_ssh_http" {
    name = var.ec2_sg_name
    description = "Enable the Port 22(SSH) & 80(Http)"
    vpc_id = var.vpc_id

    # ssh for terraform remote exec
    ingress {
        description = "Allow remote SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # enable http
    ingress {
        description = "Allow Http request from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # enable https
    ingress {
        description = "Allow Https request from anywhere"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        description = "Allow outgoing request"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name  = "Sg-ssh-http"
    }
  
}
# RDS for sg
resource "aws_security_group" "rds_mysql_sg" {
    name = var.rds_mysql_sg_name
    description = "Allow access to RDS from EC2 present in public subnet"
    vpc_id = var.vpc_id

    # ssh for terraform remote exec
    ingress {
        description = "Allow 3306 port to access mysql"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = var.public_subnet_cidr_block #replace with your EC2 instance sg cidr_block
    }
    
    tags = {
      Name  = "Sg-rds-mysql"
    }
  
}

resource "aws_security_group" "sg_python_api" {
    name = var.ec2_sg_name_for_python_api
    description = "Enable the Port 5000 for python api"
    vpc_id = var.vpc_id

    # ssh for terraform remote exec
    ingress {
        description = "Allow  traffic on port 5000"
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
    }
    egress {
        description = "Allow outgoing request"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    
    tags = {
      Name  = "Sg-python-api"
    }
  
}