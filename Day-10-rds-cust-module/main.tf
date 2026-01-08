provider "aws" {
  
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = var.db_subnet_group
  subnet_ids = [var.subnet_1, var.subnet_2]
}

resource "aws_db_instance" "db" {
  identifier              = var.identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name

  skip_final_snapshot = true
  tags = var.tags
}
