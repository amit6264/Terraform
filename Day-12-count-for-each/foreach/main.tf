
variable "env" {
    type = list(string)
    default = ["a","c"]
  
}

resource "aws_instance" "name" {
    ami = "ami-0b46816ffa1234887"
    instance_type = "t3.micro"
    for_each = toset(var.env) # toset not folows any order like list (index)
    tags = {
        Name = each.value
    }
}