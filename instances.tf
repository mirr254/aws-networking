# creates instances based on the ami in data-sources

# this is the frontend(react app) in availability zone a
resource "aws_instance" "ZONE_A_frontend" {
  ami                         = "${data.aws_ami.frontend_ami.id}"
  availability_zone           = "${var.availability_zone_a}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.10_0_1_0_public_sbnt.id}"
  key_name                    = "${var.ssh_key}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.sg_web_server.id}"]

  tags {
    Name = "Frontend in Zone A"
  }
}

# this will create another instance in a different zone but similar to the one up there 
resource "aws_instance" "ZONE_B_frontend" {
  ami                         = "${data.aws_ami.frontend_ami.id}"
  availability_zone           = "${var.availability_zone_b}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.10_0_3_public_sbnt2.id}"
  key_name                    = "${var.ssh_key}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.sg_web_server.id}"]

  tags {
    Name = "Frontend in Zone B"
  }
}

resource "aws_instance" "API_server" {
  ami                    = "${data.aws_ami.api_ami.id}"
  availability_zone      = "${var.availability_zone_b}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${aws_subnet.10_0_2_0_private_sbnt.id}"
  key_name               = "${var.ssh_key}"
  vpc_security_group_ids = ["${aws_security_group.sg_api_server.id}"]

  tags {
    Name = "API SERVER"
  }
}
