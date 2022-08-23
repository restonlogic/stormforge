terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
    kubernetes = {
      source                = "hashicorp/kubernetes"
      version               = ">= 2.10"
      configuration_aliases = [kubernetes.mgmt, kubernetes.dev, kubernetes.qa, kubernetes.prod]
    }
    helm = {
      source                = "hashicorp/helm"
      version               = ">= 2.4.1"
      configuration_aliases = [helm.mgmt, helm.dev, helm.qa, helm.prod]
    }
  }
}
