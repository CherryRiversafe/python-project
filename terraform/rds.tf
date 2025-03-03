

resource "random_password" "rds_password" {
  length = 16
  special = true
}

resource "aws_secretsmanager_secret" "rds_password_secret" {
  name = "rds-db-password-secret"
}

resource "aws_secretsmanager_secret_version" "rds_password_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_password_secret.id
  secret_string = random_password.rds_password.result
}


resource "aws_secretsmanager_secret" "db_user" {
  name                    = "rds_db_user"
  description             = "Service Account Username for the API"
  recovery_window_in_days = 0
  tags = {
    Name        = "db_user"
  }
}


resource "aws_secretsmanager_secret_version" "api_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = var.db_username
}


resource "aws_db_instance" "my_bucket_list" {
  identifier             = "mybucketlist"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  username               = var.db_username
  password               = aws_secretsmanager_secret_version.rds_password_secret_version.secret_string
  vpc_security_group_ids = [aws_security_group.rds_sec_group.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_db_parameter_group" "my_bucket_list" {
  name   = "mybucketlist"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_security_group" "rds_sec_group" {
  name        = "bucket-list-rds"
  description = "Allow local traffic to rds"
  vpc_id      = "vpc-a3ce40cb"
  ingress{
    cidr_blocks         = ["188.74.98.128/32"]
    from_port         = 5432
    protocol       = "tcp"
    to_port           = 5432
  }
}


