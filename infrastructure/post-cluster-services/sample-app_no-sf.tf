resource "kubernetes_namespace" "without-sf" {
  metadata {
    name = local.no-sf
  }
}

data "kubectl_path_documents" "without-sf" {
  pattern = "${path.module}/../yamls/boutique.yaml"
  vars = {
    NAMESPACE  = local.no-sf
    FRONTEND_ADDR = "frontend:80"
  }
  depends_on = [kubernetes_namespace.without-sf]
}

resource "kubectl_manifest" "without-sf" {
  count     = 23
  yaml_body = element(data.kubectl_path_documents.without-sf.documents, count.index)

  depends_on = [kubernetes_namespace.without-sf]
}

#Create without-sf ingress
data "kubectl_path_documents" "without-sf_ingress" {
  pattern = "${path.module}/../yamls/service-ingress.yaml"
  vars = {
    project             = var.project_config.name
    service             = "frontend"
    short_service       = local.no-sf
    service_port        = 80
    dns_domain          = var.dns_domain
    ingress_namespace   = local.no-sf
    service_namespace   = local.no-sf
    acm_certificate_arn = data.aws_acm_certificate.issued.arn
    group_number        = 2
  }
}

resource "kubectl_manifest" "without-sf_ingress" {

  yaml_body = element(data.kubectl_path_documents.without-sf_ingress.documents, 1)

  depends_on = [kubernetes_namespace.without-sf]
}