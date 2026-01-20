provider "aws" {
  region = "eu-north-1"  # replace with your region
}

# Example EC2 instance
resource "aws_instance" "sql_runner" {
  ami                         = "ami-0b46816ffa1234887" # Amazon Linux 2
  instance_type               = "t3.micro"
  key_name                    = "project"                # Replace with your key pair name
  associate_public_ip_address = true

  tags = {
    Name = "SQL Runner"
  }
}

# RDS Instance
resource "aws_db_instance" "mysql_rds" {
  identifier            = "my-mysql-db"
  engine                = "mysql"
  instance_class        = "db.t3.micro"
  username              = "admin"
  password              = "Password123!"
  db_name               = "dev"
  allocated_storage     = 20
  skip_final_snapshot   = true
  publicly_accessible   = true
}

# Secrets Manager for RDS credentials
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "rds-credentials"
}

resource "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = aws_db_instance.mysql_rds.username
    password = aws_db_instance.mysql_rds.password
  })
}

# Deploy SQL remotely
resource "null_resource" "remote_sql_exec" {
  depends_on = [aws_db_instance.mysql_rds, aws_instance.sql_runner, aws_secretsmanager_secret_version.rds_secret_value]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/HP/Downloads/project.pem") # PEM file path
    host        = aws_instance.sql_runner.public_ip
  }

  # Copy SQL file to EC2
  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  # Execute SQL on RDS
 provisioner "remote-exec" {
  inline = [
    "sudo yum install -y mysql",
    "sleep 10",
    <<-EOT
mysql -h ${aws_db_instance.mysql_rds.address} \
  -u ${jsondecode(aws_secretsmanager_secret_version.rds_secret_value.secret_string)["username"]} \
  -p${jsondecode(aws_secretsmanager_secret_version.rds_secret_value.secret_string)["password"]} \
  < /tmp/init.sql
EOT
  ]
}



  triggers = {
    always_run = timestamp() # trigger every time
  }
}
