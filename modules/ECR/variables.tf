variable "repositories" {
  description = "List of ECR repositories"
  type        = list(string)
  default     = ["model-serving"]
}