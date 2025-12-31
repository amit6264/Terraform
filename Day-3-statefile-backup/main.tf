resource "aws_instance" "name" {
  ami = "ami-0b46816ffa1234887"
  instance_type = "t3.micro"
  tags = {
    Name ="test"
  }

}
resource "aws_s3_bucket" "dev" {
    bucket = "amit-patidar-123321"
}

resource "aws_s3_bucket_versioning" "dev" {
  bucket = aws_s3_bucket.dev.id
  versioning_configuration {
    status = "Enabled"
  }
}