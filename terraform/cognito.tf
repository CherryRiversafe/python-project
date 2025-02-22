
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name
  
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true
  }

  lifecycle {

    ignore_changes = [
      password_policy,
      schema
    ]
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  auto_verified_attributes = ["email"]
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }

  password_policy {
    minimum_length    = 6
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_attributes = ["email"]
  
}


resource "aws_cognito_user_pool_client" "client" {
  name                   = "cognito-client"
  user_pool_id           = aws_cognito_user_pool.user_pool.id
  generate_secret        = false
  refresh_token_validity = 1
  access_token_validity  = 1
  id_token_validity      = 1
  token_validity_units{
    access_token  = "hours"
    refresh_token = "hours"
    id_token      = "hours"
  }

  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows           = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]   
}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = "bucketlistapp"
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
}