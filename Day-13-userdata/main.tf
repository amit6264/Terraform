
provider "aws" {
  
}
resource "aws_instance" "server" {
  ami                         = "ami-0b46816ffa1234887" # Ubuntu AMI
  instance_type               = "t3.micro"
  user_data = file("test.sh")

  tags = {
    Name = "UbuntuServer"
  }
}