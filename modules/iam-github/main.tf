# ━━━━━━━━━━━━━━━━━━━━━━━━━━
# GitHub Actions IAM Role
# ━━━━━━━━━━━━━━━━━━━━━━━━━━
resource "aws_iam_role" "github_actions" {
  name = "github-actions-mlops"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::709598629349:oidc-provider/token.actions.githubusercontent.com"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:FatimaGhi/*:*"
        }
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_actions" {
  name = "github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR — build o push images
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "*"
      },
      # EKS — kubectl access
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      },
      # S3 — DVC data access
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::mlops-mlflow-artifacts-709598629349",
          "arn:aws:s3:::mlops-mlflow-artifacts-709598629349/*"
        ]
      }
    ]
  })
}

# # ━━━━━━━━━━━━━━━━━━━━━━━━━━
# # EKS aws-auth — give kubectl access
# # ━━━━━━━━━━━━━━━━━━━━━━━━━━
# resource "kubernetes_config_map_v1_data" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = "arn:aws:iam::709598629349:role/github-actions-mlops"
#         username = "github-actions"
#         groups   = ["system:masters"]
#       }
#     ])
#   }

#   force = true

#   depends_on = [aws_iam_role.github_actions]
# }