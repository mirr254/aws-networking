#aws_vpc as type and default as the name 
resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "DevOps VPC"
  }
}

#define the public subnet
resource "aws_subnet" "10_0_1_0_public_sbnt" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "us-east-2c"

  tags {
    Name = " Public subnet "
  }
}

#define the private subnet
resource "aws_subnet" "10_0_2_0_private_sbnt" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "us-east-2b"

  tags {
    Name = " Private subnet for db and API"
  }
}

# create an internet gateway to make our public subnet accessible to the internet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${ aws_vpc.default.id}"

  tags {
    Name = "VPC Internet Gatewy"
  }
}

# define a new route table for the public subnet to access the internet
# To allow traffics from the public subnet to the internet throught the NAT Gateway

#define a route table

resource "aws_route_table" "web_public_RTB" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name = "Public Subnet Route Table"
  }
}

# assign the route table to the public subnet
resource "aws_route_table_association" "web_public_RTB" {
  subnet_id      = "${aws_subnet.10_0_1_0_public_sbnt.id}"
  route_table_id = "${aws_route_table.web_public_RTB.id}"
}

#create a security group for each subnet
# public subnet security group
resource "aws_security_group" "sg_web_server" {
  name        = "Public_Sbnt_SG"
  description = " Allow all HTTP/HTTPS and SSH connection"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # https 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "Web Server SG"
  }
}

#Define a security group for the private subnet
resource "aws_security_group" "sg_api_server" {
  name        = "Private sbnt SG"
  description = "This will allow traffic from the public subnet "

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  #allow ssh 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  #allow ping 
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  # allow postgres to connect to this sg from public subnet
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Api server SG"
  }
}
