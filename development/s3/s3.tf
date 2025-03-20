variable "bucket_name" {}
variable "name" {}
variable "environment" {}








resource "aws_s3_bucket" "rm-state-bucket" {
    bucket = var.bucket_name

    tags = {
      Name = var.name
      Enviornment = var.environment
    }
  

}