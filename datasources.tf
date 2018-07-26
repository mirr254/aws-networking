data "aws_ami" "frontend_ami" {
  filter {
    name   = "name"        #filter by name of the AMI 
    values = ["Frontend*"] #filter by name starting with frontend and any other character after that
  }

  most_recent = true
}

# api ami look up 
data "aws_ami" "api_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["API*"]
  }
}

# data "aws_ami" "db_server_ami" {
#   most_recent = true


#   filter = {
#     name   = "name"
#     values = ["db_server*"]
#   }
# }

