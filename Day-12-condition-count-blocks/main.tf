# variable "create_ec2" {
#   type    = bool
#   default = false
# }

# resource "aws_instance" "app" {
#   count = var.create_ec2 ? 1 : 0

#   ami           = "ami-0b46816ffa1234887"
#   instance_type = "t3.micro"
# }


variable "azs" {
  default = ["ap-south-1a", "ap-south-1b"]
}

resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "public-${count.index}"
  }
}