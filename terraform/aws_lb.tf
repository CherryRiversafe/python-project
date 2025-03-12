# resource "aws_lb" "bucketlist_alb" {
#   name               = "bucketlist-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.ekslb_sec_group.id]
#   subnets            = aws_subnet.public[*].id
#   enable_cross_zone_load_balancing = true

#   tags = {
#     Environment = "dev"
#   }

# }

# resource "aws_lb_listener" "bucketlist_alb_listener" {
#   load_balancer_arn = aws_lb.bucketlist_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.bucketlist_tg.arn
#   }
# }

# resource "aws_security_group" "ekslb_sec_group" {
#   name        = "bucket-list-lb"
#   description = "Allow HTTP and HTTPS traffic to load balancer"
#   vpc_id      = aws_vpc.eks_vpc.id

#   ingress {
#     description = "HTTP from anywhere"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTPS from anywhere"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_http_https"
#   }
# }


# resource "aws_lb_target_group" "bucketlist_tg" {
#   name        = "bucketlist-target-group"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.eks_vpc.id
#   target_type = "ip"

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 10
#     timeout             = 10
#     interval            = 60
#     path                = "/"
#   }
# }



# # resource "aws_lb_target_group_attachment" "tg_attachment" {
# #   target_group_arn = aws_lb_target_group.bucketlist_tg.arn
# #   target_id        = aws_lb.bucketlist_alb.id
# #   port             = 80
# # }
