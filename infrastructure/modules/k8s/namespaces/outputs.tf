# output "ns" {
#   default = var.environment == "mgmt" ? kubernetes_namespace_v1.ns_mgmt.metadata.0.name : null
# }

# output "ns" {
#   default = var.environment == "dev" ? kubernetes_namespace_v1.ns_dev.metadata.0.name : null
# }

# output "ns" {
#   default = var.environment == "qa" ? kubernetes_namespace_v1.ns_qa.metadata.0.name : null
# }

# output "ns" {
#   default = var.environment == "prod" ? kubernetes_namespace_v1.ns_prod.metadata.0.name : null
# }