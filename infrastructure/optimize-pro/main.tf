data "aws_secretsmanager_secret_version" "optimize-secret" {
  secret_id = var.secrets.stormforge
}

resource "helm_release" "optimize-pro" {
  name             = "optimize-pro"
  repository       = "oci://registry.stormforge.io/library"
  chart            = "optimize-pro"
  namespace        = "stormforge-system"
  atomic           = true
  create_namespace = false
  values           = [data.aws_secretsmanager_secret_version.optimize-secret.secret_string]
}

