terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.87.0"
    }
  }
  backend "s3" {
    bucket = "dev-proj-005-rm-state-bucket"
    key    = "devops-proj-005/terraform.tfstate"
    region = "us-east-1"

  }
}

provider "aws" {
  # Configuration options
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]

}

