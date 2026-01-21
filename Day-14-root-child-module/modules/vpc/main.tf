resource "aws_vpc" "name" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.subnet_1_cidr
  availability_zone = var.az1
}

resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.subnet_2_cidr
  availability_zone = var.az2
}

output "subnet_1_id" {
  value = "${aws_subnet.name.id}"
}

output "subnet_2_id" {
  value = "${aws_subnet.subnet_2.id}"
}