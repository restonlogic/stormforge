terraform {
  required_providers {
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = ">= 2.7.1"
      configuration_aliases = [kubernetes.mgmt, kubernetes.dev, kubernetes.qa, kubernetes.prod]
    }
  }
}
# terraform {
#   required_version = ">= 0.13.1"

#   required_providers {
#     # aws = {
#     #   source  = "hashicorp/aws"
#     #   version = ">= 3.72"
#     # }
#     tls = {
#       source  = "hashicorp/tls"
#       version = ">= 3.0"
#     }
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.10"
#     }
#   }
# }

# # provider "kubernetes" {
# #   alias  = "mgmt"

# #   host                   = aws_eks_cluster.this[0].endpoint
# #   cluster_ca_certificate = base64decode(aws_eks_cluster.this[0].certificate_authority[0].data)
# #   token                  = aws_eks_cluster.this[0].token
# # }

# # provider "kubernetes" {
# #   alias  = "dev"

# #   host                   = aws_eks_cluster.this[0].endpoint
# #   cluster_ca_certificate = base64decode(aws_eks_cluster.this[0].certificate_authority[0].data)
# #   token                  = aws_eks_cluster.this[0].token
# # }

# # provider "kubernetes" {
# #   alias  = "qa"

# #   host                   = aws_eks_cluster.this[0].endpoint
# #   cluster_ca_certificate = base64decode(aws_eks_cluster.this[0].certificate_authority[0].data)
# #   token                  = aws_eks_cluster.this[0].token
# # }
