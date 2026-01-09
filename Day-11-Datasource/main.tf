provider "aws" {
  
}

data "aws_subnet" "name" {
  filter {
    name = "tag:Name"
    values = ["dev"]
  }
}

data "aws_ami" "ami_id" {
  most_recent = true
  owners = ["amazon"]

   filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
             filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
        filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

data "aws_ec2_instance_type" "type" {
  instance_type = "t3.micro"
}


resource "aws_instance" "name" {
  ami = data.aws_ami.ami_id.id
  instance_type = data.aws_ec2_instance_type.type.id
  subnet_id = data.aws_subnet.name.id
}