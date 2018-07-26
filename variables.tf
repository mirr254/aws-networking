# This file contains environment specific configuration like region name, CIDR blocks, and AWS credentials

variable "aws_region" {
  description = "Region for the VPC"
  default     = "us-east-2"
}

variable "availability_zone_a" {
  description = "Front end availability zone B"
  default     = "us-east-2c"
}

variable "availability_zone_b" {
  description = "Front end availability zone B"
  default     = "us-east-2b"
}

variable "instance_type" {
  description = "describe which instance type to create"
  default     = "t2.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "10.0.2.0/24"
}

variable "ami" {
  description = "Ubuntu 16.0.4 server ami"
  default     = "ami-5e8bb23b"
}

variable "shared_credentials_file" {
  default = "/Users/shammir/.aws/credentials"
}

variable "profile" {
  default = "terraform"
}

variable "ssh_key" {
  default = "new-cp3-api-key-pair"
}
