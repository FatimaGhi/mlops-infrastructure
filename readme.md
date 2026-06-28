# MLOps Infrastructure

Infrastructure as Code (IaC) for the End-to-End MLOps Platform on Cloud, provisioned entirely via Terraform on AWS.

## Architecture

This repository manages the complete AWS infrastructure for the MLOps platform:

- **VPC** — Isolated network with public/private subnets across 3 availability zones (eu-west-1a, eu-west-1b, eu-west-1c)
- **EKS** — Managed Kubernetes cluster (v1.31) with 2 worker nodes (t3.medium)
- **RDS** — PostgreSQL database (db.t3.micro) as MLflow metadata backend
- **S3** — Object storage for MLflow artifacts, DVC data and production data
- **ECR** — Docker image registry for model-serving
- **IAM/OIDC** — Secure authentication for GitHub Actions (no static keys)

## Repository Structure

```
infra/
├── .github/
│   └── workflows/
│       └── terraform.yml   # CI/CD pipeline (fmt, validate, plan, apply, Checkov)
├── main.tf                 # Root module
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values (gitignored)
└── modules/
    ├── VPC/                # Network (VPC, subnets, NAT Gateway)
    ├── EKS/                # Kubernetes cluster
    ├── RDS/                # PostgreSQL database
    ├── S3/                 # Object storage
    ├── ECR/                # Container registry
    ├── iam-github/         # IAM role for GitHub Actions (OIDC)
    └── eks-addons/         # ArgoCD, MLflow, monitoring, metrics-server
```

## CI/CD Pipeline

Every push to `main` triggers:

```
terraform fmt → terraform validate → terraform plan → terraform apply → Checkov scan
```

Authentication to AWS uses **OIDC** — no static AWS credentials stored in GitHub Secrets.

## Prerequisites

- AWS CLI configured
- Terraform >= 1.5.0
- kubectl
- helm

## Usage

```bash
# 1. Clone repository
git clone https://github.com/FatimaGhi/mlops-infrastructure

# 2. Initialize Terraform
terraform init

# 3. Plan
terraform plan -var="slack_webhook_url=..." -var="github_token=..."

# 4. Apply
terraform apply -var="slack_webhook_url=..." -var="github_token=..."
```

## Outputs

| Output | Description |
|---|---|
| `cluster_endpoint` | EKS API server URL |
| `cluster_name` | EKS cluster name |
| `rds_endpoint` | RDS PostgreSQL endpoint |
| `vpc_id` | VPC identifier |

## Security

- OIDC authentication for GitHub Actions (no static keys)
- Private subnets for EKS nodes and RDS
- Security groups with least privilege
- Checkov IaC security scanning in CI/CD pipeline

## Related Repositories

- [mlops-model](https://github.com/FatimaGhi/mlops-model) — ML model code and API
- [mlops-gitops](https://github.com/FatimaGhi/mlops-gitops) — Kubernetes manifests (GitOps)