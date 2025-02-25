resource "aws_s3_bucket" "bucketlist-bucket" {
  bucket = "bucketlist-frontend-2025"

  tags = {
    Name        = "bucketlist-frontend-2025"
  }
}

resource "aws_s3_bucket_public_access_block" "bucketlist-bucket" {
  bucket = aws_s3_bucket.bucketlist-bucket.id

  block_public_acls       = false
  block_public_policy     = false

  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_versioning" "bucketlist-versioning" {
  bucket = aws_s3_bucket.bucketlist-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "bucketlist" {
  bucket = aws_s3_bucket.bucketlist-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "bucketlistpolicy" {
  depends_on = [aws_s3_bucket_public_access_block.bucketlist-bucket]
  bucket = aws_s3_bucket.bucketlist-bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.bucketlist-bucket.id}/*"
        }
    ]
}
POLICY
}