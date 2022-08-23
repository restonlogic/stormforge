terraform {
  required_providers {
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = ">= 2.7.1"
      configuration_aliases = [kubernetes.mgmt, kubernetes.dev, kubernetes.qa, kubernetes.prod]
    }
  }
}
