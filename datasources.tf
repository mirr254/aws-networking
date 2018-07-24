data "aws_ami_ids" "frontend_ami" {
  owners = ["766615329279"] #owners of the created images. 

  filter {
    name   = "name"        #filter by name of the AMI 
    values = ["Frontend*"] #filter by name starting with frontend and any other character after that
  }
}

data "aws_ami_ids" "api_ami" {
  owners = ["766615329279"]

  filter {
    name   = "name"
    values = ["API*"]
  }
}

data "aws_ami_ids" "db_server_ami" {
  owners = ["766615329279"]

  filter = {
    name   = "name"
    values = ["db_server*"]
  }
}
