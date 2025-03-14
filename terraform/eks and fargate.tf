# # EKS Cluster
# resource "aws_eks_cluster" "bucketList_backend_cluster" {
#   name     = "my-fargate-cluster"
#   role_arn = aws_iam_role.eks_bucketlist_cluster_role.arn
#   version  = "1.31"

#   # bootstrap_self_managed_addons = false

#   vpc_config {
#     endpoint_private_access = false
#     endpoint_public_access = true
#     public_access_cidrs = ["0.0.0.0/0"]

#     subnet_ids = concat(aws_subnet.private[*].id, aws_subnet.public[*].id)
#   }

#   access_config {
#     authentication_mode = "API_AND_CONFIG_MAP"
#   }

#   # compute_config {
#   #   enabled = true
#   #   node_pools    = ["general-purpose"]
#   #   node_role_arn = aws_iam_role.node.arn
#   # }

#   # kubernetes_network_config {
#   #   elastic_load_balancing {
#   #     enabled = true
#   #   }
#   # }

#   # storage_config {
#   #   block_storage {
#   #     enabled = true
#   #   }
#   # }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks_bucketlist_cluster_policy,
#     aws_iam_role_policy_attachment.eks_vpc_resource_controller,
#   ]
# }

# # IAM Role for EKS Cluster
# resource "aws_iam_role" "eks_bucketlist_cluster_role" {
#   name = "eks-backetlist-cluster-role"

#  assume_role_policy = jsonencode({
#   Version = "2012-10-17"
#   Statement = [
#     {
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "eks.amazonaws.com"
#       }
#     }
#   ]
# })
# }

# resource "aws_iam_role_policy_attachment" "eks_bucketlist_cluster_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_bucketlist_cluster_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eks_bucketlist_cluster_role.name
# }

# # Fargate Profile
# # resource "aws_eks_fargate_profile" "bucketList_backend_cluster" {
# #   cluster_name           = aws_eks_cluster.bucketList_backend_cluster.name
# #   fargate_profile_name   = "default"
# #   pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
# #   subnet_ids             = aws_subnet.private[*].id

# #   selector {
# #     namespace = "default"
# #      labels = {
# #      app = "bucketList"
# #   }
# #   }
# # }

# # IAM Role for Fargate Profile
# # resource "aws_iam_role" "fargate_pod_execution_role" {
# #   name = "eks-fargate-pod-execution-role"

# #   assume_role_policy = jsonencode({
# #     Version = "2012-10-17"
# #     Statement = [{
# #       Action = "sts:AssumeRole"
# #       Effect = "Allow"
# #       Principal = {
# #         Service = "eks-fargate-pods.amazonaws.com"
# #       }
# #     }]
# #   })
# # }

# # resource "aws_iam_policy" "cloudwatch_access" {
# #   name = "eks_node_cloudwatch_access"
# #   policy = jsonencode({
# #     Version = "2012-10-17"
# #     Statement = [
# #       {
# #         Effect = "Allow"
# #         Action = [
# #           "logs:CreateLogStream",
# #           "logs:PutLogEvents",
# #           "logs:DescribeLogStreams"
# #         ],
# #         Resource = "arn:aws:logs:*:*:log-group/aws/containerinsights/*"
# #       } 
# #     ]
# #   })
# # }

# # resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
# #   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
# #   role       = aws_iam_role.fargate_pod_execution_role.name
# # }

# # resource "aws_iam_role_policy_attachment" "fargate_pod_execution_cloudwatch_role_policy" {
# #   policy_arn = aws_iam_policy.cloudwatch_access.arn
# #   role       = aws_iam_role.fargate_pod_execution_role.name
# # }

# resource "aws_eks_node_group" "bucketlist_node_group" {
#   cluster_name = aws_eks_cluster.bucketList_backend_cluster.name
#   node_group_name = "bucketlist-node-group"
#   node_role_arn = aws_iam_role.node_role.arn
#   subnet_ids = aws_subnet.private[*].id

#   scaling_config {
#     desired_size = 2
#     max_size = 2
#     min_size = 2
#   }

#   ami_type = "BOTTLEROCKET_x86_64"
#   capacity_type = "ON_DEMAND"
# }

# resource "aws_iam_role" "node_role" {
#   name = "bucketlist-node-group-role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }



# resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.node_role.name
# }

# resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.node_role.name
# }

# resource "aws_eks_access_entry" "example" {
#   cluster_name      = aws_eks_cluster.example.name
#   principal_arn     = aws_iam_role.example.arn
#   kubernetes_groups = ["group-1", "group-2"]
#   type              = "STANDARD"
# }
