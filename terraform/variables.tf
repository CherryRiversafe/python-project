variable "aws_region" {
  type = string
  description = "The region in which the resources will be created"
  default = "eu-west-2"
}

variable "access_key" {
  type = string
  description = "The aws development account access key"
}

variable "secret_key" {
  type = string
  description = "The aws development account secret key"
}

variable "user_pool_name" {
    type = string
    description = "The name of aws user pool."
    default = "bucketlist-user-pool"
}

variable "db_username" {
  description = "db service username"
  type        = string
}

