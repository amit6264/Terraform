variable "allowed_port" {
  type = map(string)
  default = {
    22 = "152.58.58.0/24"  #ssh
    80 = "0.0.0.0/0"        #http
    443 = "0.0.0.0/0"        #https
    8080 ="10.0.0.0/16"     #internal App 
    # 9000 ="10.0.1.0/16"     #jenkin
  }
}

resource "aws_security_group" "port_sg" {
    name = "Devops-amit-rule"
    description = "Allow to SG rule"

    dynamic "ingress" {
    for_each = var.allowed_port
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
     
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project-SG"
  }

}