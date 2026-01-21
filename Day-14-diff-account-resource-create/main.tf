resource "aws_instance" "name" {
  ami = "ami-0b46816ffa1234887"
  instance_type = "t3.micro"
}

resource "aws_s3_bucket" "name" {
  bucket = "amit-ptydr-622110"
  provider = aws.test
}