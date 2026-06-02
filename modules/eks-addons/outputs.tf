output "argocd_namespace" {
  value = helm_release.argocd.namespace
}

output "nginx_namespace" {
  value = helm_release.nginx_ingress.namespace
}