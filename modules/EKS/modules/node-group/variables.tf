variable "cluster_name" {}

variable "node_role_arn" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "node_sg_id" {}