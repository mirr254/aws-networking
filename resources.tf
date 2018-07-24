#define ssh key pair the instances to connect
resource "aws_key_pair" "key_pair" {
  key_name   = "kungu_key_pair"
  public_key = "${file("${var.key_path}")}"
}
