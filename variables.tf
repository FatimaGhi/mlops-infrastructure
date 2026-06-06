variable "aws_region" {
  default = "eu-west-1"
}
variable "cluster_name" {
  default = "mlops-cluster"
}
variable "eks_version" {
  default = "1.31"
}

variable "my_ip" {
  description = "My IP for EKS access"
  type        = string
}