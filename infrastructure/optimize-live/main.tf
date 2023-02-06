data "aws_secretsmanager_secret_version" "optimize-secret" {
  secret_id = var.secrets.stormforge
}

resource "helm_release" "optimize-live" {
  name       = "optimize-live"
  repository = "https://registry.stormforge.io/chartrepo/library/"
  chart      = "optimize-live"
  version    = var.optimize.live_helm_version
  namespace  = "stormforge-system"

  values = [data.aws_secretsmanager_secret_version.optimize-secret.secret_string]

  set {
    name  = "metricsURL"
    value = "http://prometheus-server.monitoring.svc:80"
  }
}