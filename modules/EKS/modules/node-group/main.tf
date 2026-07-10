resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "mlops-workers"

  node_role_arn = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 5
  }

  instance_types = ["t3.medium"]

  capacity_type = "ON_DEMAND"

  ami_type = "AL2023_x86_64_STANDARD"

  disk_size = 30

  depends_on = []
}