locals {
    with = "with-sf"
    without = "without-sf"
}


#Create with-sf ingress
data "kubectl_path_documents" "with-sf_ingress" {
  pattern = "${path.module}/../yamls/service-ingress.yaml"
  vars = {
    project             = var.project_config.name
    service             = "frontend"
    short_service       = local.with
    service_port        = 80
    dns_domain          = var.eks_cluster_domain
    ingress_namespace   = local.with
    service_namespace   = local.with
    acm_certificate_arn = data.aws_acm_certificate.issued.arn
    group_number        = 1
  }
}

resource "kubectl_manifest" "with-sf_ingress" {

  yaml_body = element(data.kubectl_path_documents.with-sf_ingress.documents, 1)
}

#Create without-sf ingress
data "kubectl_path_documents" "without-sf_ingress" {
  pattern = "${path.module}/../yamls/service-ingress.yaml"
  vars = {
    project             = var.project_config.name
    service             = "frontend"
    short_service       = local.without
    service_port        = 80
    dns_domain          = var.eks_cluster_domain
    ingress_namespace   = local.without
    service_namespace   = local.without
    acm_certificate_arn = data.aws_acm_certificate.issued.arn
    group_number        = 2
  }
}

resource "kubectl_manifest" "without-sf_ingress" {

  yaml_body = element(data.kubectl_path_documents.without-sf_ingress.documents, 1)
}