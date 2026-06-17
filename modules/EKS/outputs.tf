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
  value = module.eks_cluster.oidc_provider
}

output "node_sg_id" {
  value = module.security_groups.node_sg_id
}

output "oidc_provider_arn" {
  value = module.eks_cluster.oidc_provider_arn
}
output "node_group_name" {
  value = module.node_group.node_group_name
}