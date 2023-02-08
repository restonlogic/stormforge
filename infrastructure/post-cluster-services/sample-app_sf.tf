# resource "kubernetes_namespace" "with-sf" {
#   metadata {
#     name = local.sf
#   }
# }

# data "kubectl_path_documents" "with-sf" {
#   pattern = "${path.module}/../yamls/boutique.yaml"
#   vars = {
#     NAMESPACE  = local.sf
#     FRONTEND_ADDR = "frontend:80"
#   }
#   depends_on = [kubernetes_namespace.with-sf]
# }

# resource "kubectl_manifest" "with-sf" {
#   count     = 23
#   yaml_body = element(data.kubectl_path_documents.with-sf.documents, count.index)

#   depends_on = [kubernetes_namespace.with-sf]
# }

# #Create with-sf ingress
# data "kubectl_path_documents" "with-sf_ingress" {
#   pattern = "${path.module}/../yamls/service-ingress.yaml"
#   vars = {
#     project             = var.project_config.name
#     service             = "frontend"
#     short_service       = local.sf
#     service_port        = 80
#     dns_domain          = var.dns_domain
#     ingress_namespace   = local.sf 
#     service_namespace   = local.sf
#     acm_certificate_arn = data.aws_acm_certificate.issued.arn
#     group_number        = 1
#   }
# }

# resource "kubectl_manifest" "with-sf_ingress" {

#   yaml_body = element(data.kubectl_path_documents.with-sf_ingress.documents, 1)

#   depends_on = [kubernetes_namespace.with-sf]
# }
