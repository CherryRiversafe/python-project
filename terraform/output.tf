output "DB_USERNAME" {
  description = "bucket list db suer name"
  value       =  aws_secretsmanager_secret.db_user.arn
}

output "DB_PASSWORD" {
  description = "bucket list db password"
  value       = aws_secretsmanager_secret.rds_password_secret.name
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.my_bucket_list.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.my_bucket_list.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.my_bucket_list.username
  sensitive   = true
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.my_bucket_list.endpoint
}