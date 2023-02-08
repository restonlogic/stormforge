module "helm_addon" {
  source            = "../helm-addon"
  manage_via_gitops = var.manage_via_gitops
  helm_config       = local.helm_config
  set_values        = local.amp_config_values
  irsa_config       = null
  addon_context     = var.addon_context

  depends_on = [kubernetes_namespace_v1.prometheus]
}

module "irsa_amp_ingest" {
  count = var.enable_amazon_prometheus ? 1 : 0

  source = "../irsa"

  kubernetes_namespace        = local.helm_config["namespace"]
  create_kubernetes_namespace = false
  kubernetes_service_account  = local.amazon_prometheus_ingest_service_account
  irsa_iam_policies           = [aws_iam_policy.ingest[0].arn]
  addon_context               = var.addon_context

  depends_on = [kubernetes_namespace_v1.prometheus]
}

module "irsa_amp_query" {
  count                       = var.enable_amazon_prometheus ? 1 : 0
  source                      = "../irsa"
  kubernetes_namespace        = local.helm_config["namespace"]
  create_kubernetes_namespace = false
  kubernetes_service_account  = "amp-query"
  irsa_iam_policies           = [aws_iam_policy.query[0].arn]
  addon_context               = var.addon_context

  depends_on = [kubernetes_namespace_v1.prometheus]
}

