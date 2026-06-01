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
  bucket_name = "mlops-mlflow-artifacts"
}