resource "kubernetes_namespace_v1" "ns_mgmt" {

  count = var.environment == "mgmt" ? 1 : 0

  provider = kubernetes.mgmt

  metadata {
    annotations = {
      name = var.namespace
    }
    labels = var.labels

    name = var.namespace
  }
}

resource "kubernetes_namespace_v1" "ns_dev" {

  count = var.environment == "dev" ? 1 : 0

  provider = kubernetes.dev

  metadata {
    annotations = {
      name = var.namespace
    }
    labels = var.labels

    name = var.namespace
  }
}

resource "kubernetes_namespace_v1" "ns_qa" {

  count = var.environment == "qa" ? 1 : 0

  provider = kubernetes.qa

  metadata {
    annotations = {
      name = var.namespace
    }
    labels = var.labels

    name = var.namespace
  }
}

resource "kubernetes_namespace_v1" "ns_prod" {

  count = var.environment == "prod" ? 1 : 0

  provider = kubernetes.prod

  metadata {
    annotations = {
      name = var.namespace
    }
    labels = var.labels

    name = var.namespace
  }
}


