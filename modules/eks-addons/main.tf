# EBS CSI DRIVER
resource "helm_release" "ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "2.28.0"

  values = [
    yamlencode({
      defaultStorageClass = {
        enabled = true
      }
    })
  ]
}

# NGINX INGRESS
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  version          = "4.9.0"
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
          }
        }
      }
    })
  ]

  depends_on = [helm_release.ebs_csi_driver]
}

# ARGOCD
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "6.7.0"
  create_namespace = true

  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]

  depends_on = [helm_release.nginx_ingress]
}

# ARGOCD BOOTSTRAP (APP OF APPS)
resource "helm_release" "argocd_bootstrap" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  namespace  = "argocd"
  version    = "1.4.1"

  values = [
    yamlencode({
      applications = [{
        name      = "app-of-apps"
        namespace = "argocd"
        project   = "default"
        source = {
          repoURL        = "https://github.com/FatimaGhi/mlops-gitops"
          targetRevision = "main"
          path           = "bootstrap"
        }
        destination = {
          server    = "https://kubernetes.default.svc"
          namespace = "argocd"
        }
        syncPolicy = {
          automated = {
            prune    = true
            selfHeal = true
          }
        }
      }]
    })
  ]

  depends_on = [helm_release.argocd]
}

resource "aws_iam_policy" "mlflow_s3" {
  name = "mlflow-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:iam::${var.aws_account_id}:*",
        "arn:aws:s3:::mlops-mlflow-artifacts-709598629349",
        "arn:aws:s3:::mlops-mlflow-artifacts-709598629349/*"
      ]
    }]
  })
}