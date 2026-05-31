
# IAM


module "iam" {
  source = "./modules/iam"

  cluster_name = var.cluster_name
}


# SECURITY GROUPS


module "security_groups" {
  source = "./modules/security-groups"

  vpc_id      = var.vpc_id
  cluster_name = var.cluster_name
}


# EKS CLUSTER


module "eks_cluster" {
  source = "./modules/eks-cluster"

  cluster_name = var.cluster_name

  eks_version = var.eks_version

  cluster_role_arn = module.iam.cluster_role_arn

  private_subnet_ids = var.private_subnet_ids

  cluster_sg_id = module.security_groups.cluster_sg_id
}


# NODE GROUP


module "node_group" {
  source = "./modules/node-group"

  cluster_name = module.eks_cluster.cluster_name

  node_role_arn = module.iam.node_role_arn

  private_subnet_ids = var.private_subnet_ids

  node_sg_id = module.security_groups.node_sg_id
}