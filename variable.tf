variable "aws_region" {
    description = "AWS Region to delpoy the resources"
    default = "us-east-1" 
     
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    default = "10.0.0.0/16"  
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    default = "10.0.1.0/24"  
}

variable "private_subnet-cidr" {
  description = "CIDR block for the private subnet"
  default = "10.0.2.0/24"

}

variable "trusted_ips" {
    description = "List of trusted IPs for the SSH access"
    type = list(string)
    default = [ "10.0.5.0/24" ]
  
}

variable "bastion_ami" {
    description = "AMI ID for the bastion instance host"  
    default = ""
}

variable "bastion_instance_type" {
    description = "Instance type for the bastion host"
    default = "t2.micro"  
}

variable "ssh_key_name" {
  description = "SSH key name for accessing instances"
  
}

