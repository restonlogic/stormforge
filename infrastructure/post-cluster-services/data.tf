data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "eks" {
  name = var.project_config.cluster_name
}

data "aws_acm_certificate" "issued" {
  domain   = var.acm_certificate_domain
  statuses = ["ISSUED"]
}

# data "aws_eks_cluster_auth" "eks" {
#   name = var.project_config.cluster_name
# }

# data "aws_vpc" "main" {
#   filter {
#     name   = "tag:Name"
#     values = [var.vpc_config.name]
#   }
# }

# data "aws_subnets" "public" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.main.id]
#   }
#   filter {
#     name   = "tag:Type"
#     values = ["${var.project_config.name} Public Subnet"] # insert values here
#   }
# }

# data "aws_subnets" "private" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.main.id]
#   }
#   filter {
#     name   = "tag:Type"
#     values = ["${var.project_config.name} Private Subnet"] # insert values here
#   }
# }

# data "aws_subnets" "database" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.main.id]
#   }
#   filter {
#     name   = "tag:Type"
#     values = ["${var.project_config.name} Database Subnet"] # insert values here
#   }
# }

# data "aws_acm_certificate" "this" {
#   domain = var.dns_domain
#   types  = ["AMAZON_ISSUED"]
# }

# data "aws_secretsmanager_secret_version" "eks_secrets" {
#   secret_id = "/${var.project_config.name}/eks-secrets"
# }

# data "aws_route53_zone" "dns_domain" {
#   name         = var.dns_domain
#   private_zone = false
# }

# data "aws_ami" "eks" {
#   owners      = ["amazon"]
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amazon-eks-node-${jsondecode(data.aws_secretsmanager_secret_version.eks_secrets.secret_string)["eks_cluster_version"]}-*"]
#   }
# }

# data "aws_ami" "bottlerocket" {
#   owners      = ["amazon"]
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["bottlerocket-aws-k8s-${jsondecode(data.aws_secretsmanager_secret_version.eks_secrets.secret_string)["eks_cluster_version"]}-x86_64-*"]
#   }
# }

# data "aws_secretsmanager_secret_version" "deploy_user_secrets" {
#   secret_id = "/${var.project_config.name}/deploy-user-secrets"
# }
