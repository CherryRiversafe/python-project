# resource "aws_vpc" "rds_vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   tags = {
#     Name = "rds-vpc"
#   }
# }

# resource "aws_subnet" "public" {
#   count             = 2
#   vpc_id            = aws_vpc.rds_vpc.id
#   cidr_block        = "10.0.${count.index + 101}.0/24"
#   availability_zone = data.aws_availability_zones.available.names[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name                     = "rds-public-${count.index + 1}"
#   }
# }

# resource "aws_internet_gateway" "rds_igw" {
#   vpc_id = aws_vpc.rds_vpc.id

#   tags = {
#     Name = "rds-igw"
#   }
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.rds_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.rds_igw.id
#   }

#   tags = {
#     Name = "rds-public-rt"
#   }
# }

# resource "aws_route_table_association" "public" {
#   count          = 2
#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }

# data "aws_availability_zones" "available" {
#   state = "available"
# }
