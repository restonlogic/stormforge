# data "aws_secretsmanager_secret_version" "optimize-pro" {
#   secret_id = "secret/optimize-pro"
# }

# resource "kubernetes_namespace" "stormforge-system" {
#   metadata {
#     name = "stormforge-system"
#   }
# }

# resource "helm_release" "optimize-pro" {
#   name       = "optimize-controller"
#   repository = "https://registry.stormforge.io/chartrepo/library/"
#   chart      = "optimize-controller"
#   version    = "2.1.1"
#   namespace  = "stormforge-system"

#   values = [data.aws_secretsmanager_secret_version.optimize-pro.secret_string]
# }