variable "vpc_id" {}

variable "igw_id" {}

variable "nat_gateway_id" {}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}