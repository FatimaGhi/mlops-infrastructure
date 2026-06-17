variable "aws_region" {
  default = "eu-west-1"
}
variable "cluster_name" {
  default = "mlops-cluster"
}
variable "eks_version" {
  default = "1.31"
}

variable "db_username" {
  default = "mlflow_admin"
}

variable "db_password" {
  sensitive = true
  default   = "MlopsSecurePass2026!"
}
variable "slack_webhook_url" {
  sensitive = true
  default   = ""
}