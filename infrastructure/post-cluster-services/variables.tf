# terraform {
#   experiments = [module_variable_optional_attrs]
# }

variable "git_user" {}
variable "git_token" {}
variable "git_repo" {}
# variable "env_config" {}
variable "project_config" {}
# variable "microservices" {}
variable "vpc_config" {}
variable "versions_config" {}
variable "tags" {}

variable "dns_domain" {
  type        = string
  description = "Route53 domain for the cluster."
}

variable "acm_certificate_domain" {
  type        = string
  description = "Route53 certificate domain"
}