This is the demo if we need more than one subnets(Public and Private) then we can change the script accordingly

#Keywords used
# Terraform looping with count: Uses count to repeat resource creation
#count.index is the loop variable representing the current iteration 
# "${count.index +1}" dynamically appends a number to each subnet's name, etc 


# Public Subnets (Automated for multiple subnets)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)  ##Specifies how many instance of this resource Terraform should create
  #The above line dynamically calculates the number of public subnets by checking how many CIDR blocks are provided in the public_subnet_cidr variable
  vpc_id                  = aws_vpc.main.id   ##Associate to the main VPC 
  cidr_block              = var.public_subnet_cidrs[count.index]
  #[count.index] will perform as the current iteration index (0,1,2,...) of the loop 
  map_public_ip_on_launch = true   #To ensure that any resource launched in the above subnet automatically gets the IP address 

  tags = {
    Name = "PublicSubnet-${count.index + 1}"  #Name the first subnet as PublicSubnet-1 and second one as PublicSubnet-2
  }
}

##Similarly for the private Subnets 
# Private Subnets (Automated for multiple subnets)
resource "aws_subnet" "private" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}
