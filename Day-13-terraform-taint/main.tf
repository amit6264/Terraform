
provider "aws" {
  
}
resource "aws_instance" "server" {
  ami                         = "ami-0b46816ffa1234887" # Ubuntu AMI
  instance_type               = "t3.micro"

  tags = {
    Name = "UbuntuServer"
  }
}

#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply