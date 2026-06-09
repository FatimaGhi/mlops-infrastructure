variable "cluster_name" {}
variable "cluster_endpoint" {}
variable "cluster_ca" {}
variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_account_id" {
  default = "709598629349"
}
variable "oidc_provider" {
  description = "EKS OIDC provider URL"
}