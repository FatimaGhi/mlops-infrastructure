variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_node_sg_id" {}

variable "db_username" {
  default = "mlflow_admin"
}