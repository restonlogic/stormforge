terraform {
  required_providers {
    helm = {
      source                = "hashicorp/helm"
      version               = ">= 2.4.1"
      configuration_aliases = [helm.mgmt, helm.dev, helm.qa, helm.prod]
    }
  }
}