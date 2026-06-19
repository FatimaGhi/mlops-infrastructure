module "vpc" {
  source     = "./modules/VPC"
  aws_region = var.aws_region
}

module "eks" {
  source             = "./modules/EKS"
  aws_region         = var.aws_region
  cluster_name       = var.cluster_name
  eks_version        = var.eks_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = values(module.vpc.private_subnets)
  depends_on         = [module.vpc]
}

module "s3" {
  source      = "./modules/S3"
  bucket_name = "mlops-mlflow-artifacts-709598629349"
}
module "ecr" {
  source       = "./modules/ECR"
  repositories = ["model-serving"]
}
module "eks_addons" {
  source            = "./modules/eks-addons"
  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_ca        = module.eks.cluster_ca
  oidc_provider     = module.eks.oidc_provider
  node_group_name   = module.eks.node_group_name
  github_token      = var.github_token
  slack_webhook_url = var.slack_webhook_url
  depends_on        = [module.eks]
}

module "rds" {
  source = "./modules/RDS"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = values(module.vpc.private_subnets)
  eks_node_sg_id     = module.eks.node_sg_id
}

module "iam_github" {
  source = "./modules/iam-github"

  depends_on = [module.eks]
}