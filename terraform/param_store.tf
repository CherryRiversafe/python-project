
resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name  = "cognito-user-pool-id"
  type  = "String"
  value = aws_cognito_user_pool.user_pool.id
}


resource "aws_ssm_parameter" "cognito_client_id" {
  name  = "cognito-client-id"
  type  = "String"
  value = aws_cognito_user_pool_client.client.id
}


resource "aws_ssm_parameter" "rds_name" {
  name  = "rds-name"
  type  = "String"
  value = aws_db_instance.my_bucket_list.identifier
}


