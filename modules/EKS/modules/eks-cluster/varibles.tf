variable "cluster_name" {}
variable "eks_version" {}

variable "cluster_role_arn" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_sg_id" {}
variable "my_ip" {
  type = string
  default = "160.90.62.211/32" # replace with my ip address for security for accessing the cluster endpoint 
}