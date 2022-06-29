data "aws_secretsmanager_secret_version" "optimize-live" {
  secret_id = "secret/optimize-live"
}

resource "kubernetes_namespace" "stormforge-system" {
  metadata {
    name = "stormforge-system"
  }
}

resource "helm_release" "optimize-live" {
  name       = "optimize-live"
  repository = "https://registry.stormforge.io/chartrepo/library/"
  chart      = "optimize-live"
  version    = "0.2.2"
  namespace  = "stormforge-system"

  values = [data.aws_secretsmanager_secret_version.optimize-live.secret_string]

  set           {      
    name = "metricsURL"
    value = "http://prometheus-server.monitoring.svc:80"
  }
}