# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

#Configure the VPC
resource "aws_vpc" "main" {   ##Resource Block 
    cidr_block = var.vpc_cidr
  
  tags = {
    Name = "MainVPC"
  }
}

#Public Subnet 
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr

    tags = {
        Name= "PublicSubnet"
    }
}

#Private Subnet 
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet-cidr

    tags = {
      Name= "PrivateSubnet"
    }  
}

#Internet Gateway     
#An internet gateway is created and attached to the VPC, allowing instances in the public subnet to access the internet. 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "Internet Gateway"
    }  
}

#Public Route Table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gatewayigw.id
  }

  tags = {
    Name= "Public Route Table"
  }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id    
}

##Bastion Security Group 
resource "aws_security_group" "bastion_sg" {
    vpc_id = aws_vpc.main.id

    ingress {
        description = "allow SSH from the trusted or allowed IPs"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.trusted_ips
    }

    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "Bastion Security Group"
    }    
}

##Bastion Host 
resource "aws_instance" "bastion" {
    ami = var.bastion_ami
    instance_type = var.bastion_instance_type
    subnet_id = aws_subnet.public.id
    security_groups = [aws_security_group.bastion_sg.id]
    
    tags = {
      Name = "Bastion Host"
    } 


    /*  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install google-authenticator -y
              EOF */

}

###Private Security Group 
##Do we need to have another security Group to allow SSH from Bastion 
#If required the Private Security group than create a security group(private) attach that to the VPC and allow only SSH attach security group to the Bastion Security Group 

#Firewall
resource "aws_wafv2_web_acl" "firewall" {  ##Web based application Firewall 
  name        = "VPCFirewall"
  description = "Firewall for VPC"
  scope       = "REGIONAL"    ##This parameter specifies the scope or applicability of the AWS WAF (Web Application Firewall) rules.
##It determines whether the Web ACL will protect resources at the regional level or for global resources.

  default_action {
    allow {}
  }
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}

