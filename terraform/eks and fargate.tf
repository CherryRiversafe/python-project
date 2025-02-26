# EKS Cluster
resource "aws_eks_cluster" "bucketList_backend_cluster" {
  name     = "my-fargate-cluster"
  role_arn = aws_iam_role.eks_bucketlist_cluster_role.arn
  version  = "1.26"

  vpc_config {
    subnet_ids = concat(aws_subnet.private[*].id, aws_subnet.public[*].id)

  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_bucketlist_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
  ]
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_bucketlist_cluster_role" {
  name = "eks-backetlist-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_bucketlist_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_bucketlist_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_bucketlist_cluster_role.name
}

# Fargate Profile
resource "aws_eks_fargate_profile" "bucketList_backend_cluster" {
  cluster_name           = aws_eks_cluster.bucketList_backend_cluster.name
  fargate_profile_name   = "default-fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = aws_subnet.private[*].id

  selector {
    namespace = "default"
  }
}

# IAM Role for Fargate Profile
resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "eks-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution_role.name
}

# CoreDNS Addon
# resource "aws_eks_addon" "coredns" {
#  cluster_name      = aws_eks_cluster.bucketList_backend_cluster.name
#  addon_name        = "coredns"
#  addon_version     = "v1.8.7-eksbuild.3"
#  resolve_conflicts = "OVERWRITE"

# depends_on = [aws_eks_fargate_profile.this]
# }
