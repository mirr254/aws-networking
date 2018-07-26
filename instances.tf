# creates instances based on the ami in data-sources

# this is the frontend(react app) in availability zone a
resource "aws_instance" "frontend_in_zone_a" {
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
