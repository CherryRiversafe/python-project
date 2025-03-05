# EKS Cluster
resource "aws_eks_cluster" "bucketList_backend_cluster" {
  name     = "my-fargate-cluster"
  role_arn = aws_iam_role.eks_bucketlist_cluster_role.arn
  version  = "1.26"

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access = true
    public_access_cidr = ["0.0.0.0/0"]

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

  assume_role_policy = <<POLICY
    {
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  }
POLICY
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
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = aws_subnet.private[*].id

  selector {
    namespace = "kube-system"
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
resource "aws_iam_policy" "cloudwatch_access" {
  name = "eks_node_cloudwatch_access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:log-group/aws/containerinsights/*"
      } 
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution_role.name
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_cloudwatch_role_policy" {
  policy_arn = aws_iam_policy.cloudwatch_access.arn
  role       = aws_iam_role.fargate_pod_execution_role.name
}
