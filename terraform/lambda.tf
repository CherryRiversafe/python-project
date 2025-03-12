resource "aws_lambda_function" "backend_container" {
  function_name = "bucketlist-backend"
  role = aws_iam_role.lambda_role.arn
  package_type = "Image"
  image_uri = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
  timeout = 15

  environment {
    variables = {
      db_user_secret_name = aws_secretsmanager_secret.db_user.name
      db_password_secret_name = aws_secretsmanager_secret.rds_password_secret.name
      rds_endpoint = aws_db_instance.my_bucket_list.address 
    }
  }

#    vpc_config {
#     # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
#     subnet_ids         = ["subnet-9826f9e2"]
#     security_group_ids = [aws_security_group.rds_sec_group.id]
#   }
}


resource "aws_lambda_function_url" "backend_container_url" {
  function_name      = aws_lambda_function.backend_container.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["http://bucketlist-frontend-2025.s3-website.eu-west-2.amazonaws.com"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE"]
    allow_headers     = ["Content-Type"]
    expose_headers    = ["Date", "x-amzn-RequestId"]
    max_age           = 3600
  }
}


resource "aws_iam_role" "lambda_role" {
    name = "bucketlist-lambda-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}



resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "bucketlist-role-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
            Resource = [
                "arn:aws:logs:*:*:*"
            ]
        },
        {
            Effect = "Allow"
            Action = [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ]
            Resource = [
                "*"
            ]
        },
        {
            Effect = "Allow"
            Action = [
                "secretsmanager:GetSecret"
            ],
            Resource = [
                aws_secretsmanager_secret.rds_password_secret.arn,
                aws_secretsmanager_secret.db_user.arn
            ]
        }
    ]
  })
}



resource "aws_cloudwatch_log_group" "log_group" {
    name = "/aws/lambda/bucketlist-backend"
    retention_in_days = 14
}