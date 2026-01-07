resource "aws_vpc" "cust_vpc" {
   cidr_block =  "10.0.0.0/16"  
   tags = {
     Name= "my-vpc"
   }
}
resource "aws_subnet" "pub_sub" {
    vpc_id = aws_vpc.cust_vpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name ="pub-sub"
    }  
}
resource "aws_subnet" "pvt_sub_1" {
  vpc_id = aws_vpc.cust_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "pvt-sub-1"
  }
}
resource "aws_subnet" "pvt_sub_2" {
  vpc_id = aws_vpc.cust_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
  tags = {
    Name ="pvt-sub-2"
  }
}

resource "aws_db_subnet_group" "db_sub_GP" {
  name = "my-cust-sub-group"
  subnet_ids = [aws_subnet.pvt_sub_1.id , aws_subnet.pvt_sub_2.id]
  tags = {
    Name = "My-DB-Sub-Gp"
  }
}

# # IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role-amit-new"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

#IAM Policy Attachment for RDS Monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "default" {
  allocated_storage       = 10
  db_name                 = "mydatabase"
  identifier              = "rds-test"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  manage_master_user_password = true #rds and secret manager manage this password
  # password                = "Cloud123"
  db_subnet_group_name    = aws_db_subnet_group.db_sub_GP.id
  parameter_group_name    = "default.mysql8.0"

  # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable monitoring (CloudWatch Enhanced Monitoring)
  monitoring_interval      = 60  # Collect metrics every 60 seconds
  monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  # Enable performance insights
  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7  # Retain insights for 7 days

  # Maintenance window
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
  deletion_protection = true

  # Skip final snapshot
  skip_final_snapshot = true
  
}

# Read Replica Creation of Master DB
resource "aws_db_instance" "read_replica" {
  identifier          = "rds-test-replica"
  replicate_source_db = aws_db_instance.default.identifier
  instance_class      = "db.t3.micro"
  publicly_accessible = false
  availability_zone   = "eu-north-1a"
  skip_final_snapshot = true

  tags = {
    Name = "RDS Read Replica"
  }
}
