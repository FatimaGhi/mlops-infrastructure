variable "cluster_name" {}
variable "eks_version" {}

variable "cluster_role_arn" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_sg_id" {}