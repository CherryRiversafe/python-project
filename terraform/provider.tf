terraform{
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
        random = {
            source = "hashicorp/random"
        }
    }
    backend "s3" {
        bucket = "bucketlist-tfstate-holder"
        key = "tf-state"
        region = "eu-west-2"
    }
}
provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}