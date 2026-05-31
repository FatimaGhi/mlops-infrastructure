variable "vpc_id" {}

variable "public_subnets" {
  type = map(any)
}

variable "private_subnets" {
  type = map(any)
}