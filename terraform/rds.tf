

resource "random_password" "rds_password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "rds_password_secret" {
  name = "rds-dbs-password-secret"
}

resource "aws_secretsmanager_secret_version" "rds_password_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_password_secret.id
  secret_string = random_password.rds_password.result
}


resource "aws_secretsmanager_secret" "db_user" {
  name                    = "rds_dbs_user"
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
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"
  subnet_ids = aws_subnet.public[*].id
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
  vpc_id      = aws_vpc.rds_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_postgres_access" {
  security_group_id = aws_security_group.rds_sec_group.id
  referenced_security_group_id = aws_security_group.rds_sec_group.id
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
} 

resource "aws_vpc_security_group_ingress_rule" "allow_http_access" {
  security_group_id = aws_security_group.rds_sec_group.id
  cidr_ipv4          = "0.0.0.0/0"
  ip_protocol       = "-1"
} 

resource "aws_vpc_security_group_egress_rule" "allow_any_outbound" {
  security_group_id = aws_security_group.rds_sec_group.id
  ip_protocol       = "-1"  # All protocols
  cidr_ipv4         = "0.0.0.0/0"
}
    
    






