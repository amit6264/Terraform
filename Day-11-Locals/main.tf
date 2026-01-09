resource "aws_instance" "name" {
  ami = local.ami_id
  instance_type = local.instance_type
  tags = {
    Name = "App-${local.region}"
  }
}