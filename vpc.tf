#aws_vpc as type and default as the name 
resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}" #cidr block for the vpc
  enable_dns_hostnames = true              #) A boolean flag to enable/disable DNS hostnames in the VPC.

  tags {
    Name = "DevOps VPC" #tags to assign the vpc
  }
}

#define the public subnet
resource "aws_subnet" "10_0_1_0_public_sbnt" {
  vpc_id            = "${aws_vpc.default.id}"     #vpc to hold the subnet
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "us-east-2c"                #availability zone where the subnet will reside

  tags {
    Name = " Public subnet "
  }
}

resource "aws_subnet" "10_0_3_public_sbnt2" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "us-east-2b"
  cidr_block        = "${var.public_subnet_2_cidr}"

  tags {
    Name = "Public subnet 2"
  }
}

resource "aws_subnet" "10_0_2_0_private_sbnt" {
  vpc_id            = "${aws_vpc.default.id}"      #define the private subnet
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

  #allow all outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  #allow tcp traffic on port 80 from everywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # https traffic allowed from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ssh connection can be done from anywhere. May consider changing this for security reasons
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}" #which vpc this sg is contained in

  tags {
    Name = "Web Server SG"
  }
}

#security group for the load balancer
resource "aws_security_group" "load_balancer_SG" {
  name        = "Frontend load Balancer"
  description = "Security rules for the internet facing load balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound connections to everywhere and through any port
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }
}

resource "aws_security_group" "sg_api_server" {
  name        = "Private sbnt SG"                                 #Define a security group for the private subnet
  description = "This will allow traffic from the public subnet "

  #allow all outbound connections to everywhere and through any port
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  #allow inbound connections from the public subnet to connect to instances in this SG through port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  #allow ssh connection from the public subnet to the private instance server

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
