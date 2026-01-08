module "test" {
  source = "../Day-10-rds-cust-module"
  
  security_group_id = "sg-0b8d1b1be753f6ef3"
  subnet_1          = "subnet-07e47eebe13bede97"
  subnet_2          = "subnet-081193b2d9d3e80c5"
  db_subnet_group   = "my-db-subnet"

  identifier        = "mydb-instance"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 10

  db_name  = "customerdb"
  username = "admin"
  password = "Admin123#"

  tags = {
    Environment = "dev"
    Owner       = "amit"
  }
}
