resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cust-VPC"
  }
}

resource "aws_subnet" "pub-sub" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "eu-north-1a"
    tags = {
      Name ="pub-subnet"
    }  
}

resource "aws_subnet" "pvt-sub" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1b"
  tags = {
    Name="pvt-subnet"
  }
}

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name="cust-IG"
    }
}

resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name="pub-RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}

resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.pub-sub.id
    route_table_id = aws_route_table.name.id
  
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat_gate" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.pub-sub.id
    tags = {
      Name ="cust-Nat"
   }  
}

resource "aws_route_table" "pvt_RT" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name ="pvt-RT"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gate.id
    }
}
resource "aws_route_table_association" "nat-rt" {
    subnet_id = aws_subnet.pvt-sub.id
    route_table_id = aws_route_table.pvt_RT.id
}

resource "aws_security_group" "cust_SG" {
    name ="allow-tls"
    vpc_id = aws_vpc.name.id
    tags = {
      Name="cust-SG"
    }
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" #indicate all protocol 
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "name" {
  ami = "ami-0b46816ffa1234887"
  instance_type = "t3.micro"
  key_name = "project"
  subnet_id = aws_subnet.pub-sub.id
  vpc_security_group_ids = [aws_security_group.cust_SG.id]
  associate_public_ip_address = true

  tags = {
    Name="Bastion"
  }
}

resource "aws_instance" "pvt_ec2" {
  ami = "ami-0b46816ffa1234887"
  instance_type = "t3.micro"
  key_name = "project"
  subnet_id = aws_subnet.pvt-sub.id
  vpc_security_group_ids = [aws_security_group.cust_SG.id]

  tags ={
    Name = "backend"
  }  
}