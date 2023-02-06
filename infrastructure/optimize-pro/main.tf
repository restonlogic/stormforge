data "aws_secretsmanager_secret_version" "optimize-secret" {
  secret_id = var.secrets.stormforge
}

resource "helm_release" "optimize-pro" {
  name       = "optimize-controller"
  repository = "https://registry.stormforge.io/chartrepo/library/"
  chart      = "optimize-controller"
  version    = var.optimize.pro_helm_version
  namespace  = "stormforge-system"

  values = [data.aws_secretsmanager_secret_version.optimize-secret.secret_string]
}

