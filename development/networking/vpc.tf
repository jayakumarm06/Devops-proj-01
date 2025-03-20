variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "us_availability_zone" {}





output "dev_proj_1_vpc_id" {
    value = aws_vpc.dev_proj_1_vpc_us_east_1.id
  
}

output "dev_proj_1_public_subnets" {
    value = aws_subnet.dev_proj_1_public_subnets.*.id
  
}

output "public_subnet_cidr_block" {
    value = aws_subnet.dev_proj_1_public_subnets.*.cidr_block
  
}

# output "dev_proj_1_private_subnets" {
#     value = aws_subnet.dev_proj_1_private_subnets.*.id
  
# }




# setup VPC

resource "aws_vpc" "dev_proj_1_vpc_us_east_1" {
    cidr_block = var.vpc_cidr
    tags = {
      Name = var.vpc_name
    }
  
}

#setup public subnet
resource "aws_subnet" "dev_proj_1_public_subnets" {
    count = length(var.cidr_public_subnet)
    vpc_id = aws_vpc.dev_proj_1_vpc_us_east_1.id
    cidr_block = element(var.cidr_public_subnet,count.index)
    availability_zone = element(var.us_availability_zone,count.index)

    tags = {
      Name = "dev-proj-public-subnet-${count.index + 1}"
    }
  
}

#setup private subnet
resource "aws_subnet" "dev_proj_1_private_subnets" {
    count = length(var.cidr_private_subnet)
    vpc_id = aws_vpc.dev_proj_1_vpc_us_east_1.id
    cidr_block = element(var.cidr_private_subnet, count.index)
    availability_zone = element(var.us_availability_zone, count.index)

    tags = {
      Name = "dev-proj-private-subnet-${count.index + 1}"
    }
  
}

# setup Internet Gateway

resource "aws_internet_gateway" "dev_proj_1_public_internet_gateway" {

    vpc_id = aws_vpc.dev_proj_1_vpc_us_east_1.id

    tags = {
        Name = "dev-proj-1-igw"
    }
  
}

# public route table

resource "aws_route_table" "dev_proj_1_public_route_table" {
    vpc_id = aws_vpc.dev_proj_1_vpc_us_east_1.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev_proj_1_public_internet_gateway.id
    }

    tags = {
      Name = "dev-proj-1-public-rt"
    }
  
}

# public route table and public subnet association
resource "aws_route_table_association" "dev_proj_1_public_rt_subnet_association" {
    count = length(aws_subnet.dev_proj_1_public_subnets)
    subnet_id = aws_subnet.dev_proj_1_public_subnets[count.index].id
    route_table_id = aws_route_table.dev_proj_1_public_route_table.id
  
}

# private route table
resource "aws_route_table" "dev_proj_1_private_route_table" {
    vpc_id = aws_vpc.dev_proj_1_vpc_us_east_1.id


    tags = {
      Name = "dev-proj-1-private-rt"

    }
  
}

# private rt subnet association
resource "aws_route_table_association" "dev_proj_1_private_rt_subnet_association" {
    count = length(aws_subnet.dev_proj_1_private_subnets)
    subnet_id = aws_subnet.dev_proj_1_private_subnets[count.index].id
    route_table_id = aws_route_table.dev_proj_1_private_route_table.id
}