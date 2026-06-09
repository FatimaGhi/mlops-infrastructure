output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_ca" {
  value = module.eks_cluster.cluster_ca
}
output "oidc_provider" {
  value = replace(
    aws_eks_cluster.this.identity[0].oidc[0].issuer,
    "https://",
    ""
  )
}