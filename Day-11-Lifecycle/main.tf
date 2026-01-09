# resource "aws_s3_bucket" "name" {
#   bucket = "amit-patidar-test-bucket"


     # lifecycle {
     #   prevent_destroy = true
     # }

# }

##########ALL three lifecycle rule#############

resource "aws_instance" "name" {
    ami = "ami-0b46816ffa1234887"
    instance_type = "t3.micro"
    tags = {
      Name = "test"
    }

    # lifecycle {
    #   prevent_destroy = true
    # }
#    lifecycle {
#      ignore_changes = [ instance_type, ]
#    }
     lifecycle {
       create_before_destroy = true
     }
}