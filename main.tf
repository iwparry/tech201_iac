# launch ec2
# which cloud provider - AWS
# terraform downloads required dependencies -
# terraform init 

provider "aws" {
    region = "eu-west-1"

}

# MUST OPEN NEW GITBASH AS ADMIN AFTER ENV VAR SET UP
# If running terraform apply after destroying terraform infrastructure - need to update varaible.tf file since previous variables used will be invalid.
# 1. Create VPC, 2. IG , SG 3. SN 4. RT 5. RTA 6. EC2

# create a VPC
resource "aws_vpc" "iwan_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "tech201_iwan_terraform_vpc"
    }
}
# Subnets and IG
resource "aws_subnet" "public" {
    vpc_id = var.iwan_vpc_id
    cidr_block = "10.0.0.0/18"

    tags = {
        Name = "tech201_iwan_terraform_public_sn"
    }
}
resource "aws_subnet" "private" {
    vpc_id = var.iwan_vpc_id
    cidr_block = "10.0.240.0/20"

    tags = {
        Name = "tech201_iwan_terraform_private_sn"
    }
  
}
resource "aws_internet_gateway" "ig" {
    vpc_id = var.iwan_vpc_id

    tags = {
        Name = "tech201_iwan_terraform_ig"
    }
  
}
# Route Table(s)
resource "aws_route_table" "public_rt" {
    vpc_id = var.iwan_vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.iwan_ig_id
    }

    tags = {
        Name = "tech201_iwan_terraform_rt_public_access"
    }
}
resource "aws_route_table_association" "public_access" {
    subnet_id = var.public_sn_id
    route_table_id = var.rt_public_id
}
# resource "aws_route_table" "private_rt" {
#     vpc_id = var.iwan_vpc_id

#     route {
      
#       cidr_block = "10.0.240.0/20" 
#     }

#     route {
#         egress_only_gateway_id = 
#     }

#     tags = {
#         Name = "tech201_iwan_terraform_rt_private_access"
#     }
# }
# resource "aws_route_table_association" "private_access" {
#     subnet_id = var.private_sn_id
#     route_table_id = var.rt_privte_id
# }
# Security group
resource "aws_security_group" "app_sg" {
    name = "app_sg"
    description = "Allow connections from port 22, 80 and 3000"
    vpc_id = var.iwan_vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow our Node app to listen on port 3000"
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = {
        Name = "tech201_iwan_terraform_app_sg"
    }
}
# # launch an instance
resource "aws_instance" "app_instance" {
    ami = var.app_ami_id
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = var.key
    subnet_id = var.public_sn_id
    vpc_security_group_ids = [var.vpc_sg_id]
    tags = {
        Name = var.instance_name
    }
}

# Autoscaling group - ALB - Cloudwatch - SNS
