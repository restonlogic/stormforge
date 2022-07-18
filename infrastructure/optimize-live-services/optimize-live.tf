data "aws_secretsmanager_secret_version" "optimize-live" {
  secret_id = var.secret.name
}

resource "helm_release" "optimize-live" {
  name       = "optimize-live"
  repository = "https://registry.stormforge.io/chartrepo/library/"
  chart      = "optimize-live"
  version    = "0.2.3"
  namespace  = "stormforge-system"

  values = [data.aws_secretsmanager_secret_version.optimize-live.secret_string]

  set {
    name  = "metricsURL"
    value = "http://prometheus-server.monitoring.svc:80"
  }
}