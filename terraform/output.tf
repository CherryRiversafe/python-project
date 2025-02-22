output "DB_USERNAME" {
  description = "bucket list db suer name"
  value       =  aws_secretsmanager_secret.db_user.arn
}

output "DB_PASSWORD" {
  description = "bucket list db password"
  value       = aws_secretsmanager_secret.rds_password_secret.name
}