resource "aws_lambda_function" "backend_container" {
  function_name = "bucketlist-backend"
  role = aws_iam_role.lambda_role.arn
  package_type = "Image"
  image_uri = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
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

# resource "aws_iam_role_policy" "lambda_role_policy" {
#   name = "bucketlist-role-policy"
#   role = aws_iam_role.lambda_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#         {

#         }
#     ]
#   })
# }



resource "aws_cloudwatch_log_group" "log_group" {
    name = "/aws/lambda/bucketlist-backend"
    retention_in_days = 14
}