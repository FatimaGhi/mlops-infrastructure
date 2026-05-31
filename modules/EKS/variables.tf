variable "aws_region" {
  default = "eu-west-1"
}

variable "cluster_name" {
  default = "mlops-cluster"
}

variable "eks_version" {
  default = "1.31"
}

variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list(string)
}
