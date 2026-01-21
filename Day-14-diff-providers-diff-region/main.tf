resource "aws_s3_bucket" "name" {
    bucket = "amit-patidar-12321"
    provider = aws.test
  
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "myvpc"
    }
  
}