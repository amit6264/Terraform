resource "aws_instance" "name" {
  ami = "ami-0b46816ffa1234887"
  instance_type = "t3.micro"
  
}

resource "aws_s3_bucket" "name" {
    bucket = "amit-patidar-test-bucket"
    depends_on = [ aws_instance.name ]
  
}