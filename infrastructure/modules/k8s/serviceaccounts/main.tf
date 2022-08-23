resource "kubernetes_service_account_v1" "sa_mgmt" {

  count = var.environment == "mgmt" ? 1 : 0

  provider = kubernetes.mgmt

  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations != null ? var.annotations : {}
    labels      = var.labels
  }

  automount_service_account_token = var.automount_service_account_token
}

resource "kubernetes_service_account_v1" "sa_dev" {

  count = var.environment == "dev" ? 1 : 0

  provider = kubernetes.dev

  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations != null ? var.annotations : {}
    labels      = var.labels
  }

  automount_service_account_token = var.automount_service_account_token
}

resource "kubernetes_service_account_v1" "sa_qa" {

  count = var.environment == "qa" ? 1 : 0

  provider = kubernetes.qa

  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations != null ? var.annotations : {}
    labels      = var.labels
  }

  automount_service_account_token = var.automount_service_account_token
}


resource "kubernetes_service_account_v1" "sa_prod" {

  count = var.environment == "prod" ? 1 : 0

  provider = kubernetes.prod

  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations != null ? var.annotations : {}
    labels      = var.labels
  }

  automount_service_account_token = var.automount_service_account_token
}
