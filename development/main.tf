# module "s3" {
#   source      = "../modules/s3"
#   bucket_name = var.bucket_name
#   name        = var.key_name
#   environment = var.environment

# }


module "networking" {

  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  cidr_private_subnet  = var.cidr_private_subnet
  us_availability_zone = var.us_availability_zone


}

module "security_gp" {
  source                     = "./sg"
  ec2_sg_name                = "SG-for-ec2-enable-ssh-http-https"
  rds_mysql_sg_name          = "rd-sg"
  vpc_id                     = module.networking.dev_proj_1_vpc_id
  ec2_sg_name_for_python_api = "SG-ec2-enable-5000"
  public_subnet_cidr_block   = tolist(module.networking.public_subnet_cidr_block)

}

module "ec2" {
  source                     = "./ec2"
  ami_id                     = var.ec2_ami_id
  instance_type              = "t2.micro"
  public_key                 = var.public_key
  key_name                   = var.key_name
  subnet_id                  = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_enable_ssh_https        = module.security_gp.sg_ec2_sg_ssh_http_id
  ec2_sg_name_for_python_api = module.security_gp.sg_ec2_sg_python_api_id
  enable_public_ip_address   = true
  ec2_tag_name               = "Ubuntu-Linux-EC2"
  user_data_python_api       = templatefile("../development/template/ec2_python_api.sh", {})


}

module "lb_target_group" {
  source                   = "./loadbalancer-target-group"
  lb_target_group_name     = "dev-proj-1-lb-target-group"
  lb_target_group_port     = 5000
  lb_target_group_protocol = "HTTP"
  vpc_id                   = module.networking.dev_proj_1_vpc_id
  ec2_instance_id          = module.ec2.ec2_python_instance_id

}

module "alb" {
  source                    = "./loadbalancer"
  lb_name                   = "dev-proj-1-alb"
  lb_type                   = "application"
  is_internal               = false
  sg_enable_ssh_https       = module.security_gp.sg_ec2_sg_ssh_http_id
  subnet_ids                = tolist(module.networking.dev_proj_1_public_subnets)
  lb_listner_port           = 80
  lb_listner_protocol       = "HTTP"
  lb_listner_default_action = "forward"
  lb_target_group_arn       = module.lb_target_group.dev_proj_1_lb_target_group_arn

}

module "rds_db_instance" {
  source               = "./rds"
  db_subnet_group_name = "dev-proj-1-rds-subnet-gp"
  subnet_groups        = tolist(module.networking.dev_proj_1_public_subnets)
  rds_mysql_sg_id      = module.security_gp.sg_rds_mysql_sg_id
  mysql_db_identifier  = "mydb"
  mysql_username       = "dbuser"
  mysql_password       = "dbpassword"
  mysql_dbname         = "devprojdb"

}