data "aws_secretsmanager_secret_version" "optimize-pro" {
  secret_id = var.secrets.stormforge
}


resource "helm_release" "optimize-pro" {
  name       = "optimize-controller"
  repository = "https://registry.stormforge.io/chartrepo/library/"
  chart      = "optimize-controller"
  version    = "2.1.1"
  namespace  = "stormforge-system"

  values = [data.aws_secretsmanager_secret_version.optimize-pro.secret_string]
}