terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    kubernetes = {
      source                = "hashicorp/kubernetes"
      configuration_aliases = [kubernetes.mgmt, kubernetes.dev, kubernetes.qa, kubernetes.prod]
    }
    helm = {
      source                = "hashicorp/helm"
      configuration_aliases = [helm.mgmt, helm.dev, helm.qa, helm.prod]
    }
  }
}
