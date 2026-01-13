provider "aws" {
  
}

# resource "aws_instance" "name" {
#  ami = "ami-0b46816ffa1234887"
#  instance_type = "t3.micro"
#  count= 1
#  tags = {
#    Name ="Dev-${count.index}"
#  }

# }

variable "env" {
  type = list(string)
  default = ["dev","prod"]
}

resource "aws_instance" "name" {
  ami = "ami-0b46816ffa1234887"
  instance_type = "t3.micro"
  count = length(var.env)
  tags = {
    Name = var.env[count.index]
  }
}