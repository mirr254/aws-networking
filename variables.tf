# This file contains environment specific configuration like region name, CIDR blocks, and AWS credentials

variable "aws_region" {
  description = "Region for the VPC"
  default     = "us-east-1"
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
  default     = "ami-a9a79fcc"
}

variable "key_path" {
  description = "SSH Public Key path"
  default     = "/Users/shammir/.ssh/kungu_key_pair.pem"
}

variable "shared_credentials_file" {
  default = "/Users/shammir/.aws/credentials"
}

variable "profile" {
  default = "terraform"
}
