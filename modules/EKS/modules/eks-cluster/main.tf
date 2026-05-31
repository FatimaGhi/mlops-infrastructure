resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  version = var.eks_version

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.cluster_sg_id]

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = []
}