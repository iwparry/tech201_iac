# launch ec2
# which cloud provider - AWS
# terraform downloads required dependencies -
# terraform init 

provider "aws" {
    region = "eu-west-1"

}

# MUST OPEN NEW GITBASH AS ADMIN AFTER ENV VAR SET UP
# launch an instance
resource "aws_instance" "app_instance" {
    ami = "ami-0f69657a120c6f174"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    tags = {
        Name = "tech201-iwan-terraform-app"
    }
}
# create a VPC - subnet/s IG - RT-SG-
# Autoscaling group - ALB - Cloudwatch - SNS