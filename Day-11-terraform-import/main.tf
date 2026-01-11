resource "aws_instance" "name" {
  ami = "ami-0683ee28af6610487"
  instance_type = "t3.micro"
  tags = {
    Name ="dev"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "amit-patidar-test-bucket"
}