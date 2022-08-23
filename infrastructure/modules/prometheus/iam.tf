### deprecated
## kubernetes alb-ingress

locals {
  namespace      = local.helm_config["namespace"]
  serviceaccount = local.amazon_prometheus_ingest_service_account
}

module "irsa_amp_ingest" {
  source         = "../iam-role-for-serviceaccount"
  name           = join("-", ["irsa", local.name, var.addon_context.eks_cluster_id])
  namespace      = local.namespace
  serviceaccount = local.serviceaccount
  oidc_url       = var.addon_context.eks_oidc_issuer_url
  oidc_arn       = var.addon_context.eks_oidc_provider_arn
  policy_arns    = [aws_iam_policy.ingest.arn]
  environment    = var.environment
  tags           = var.addon_context.tags
}

resource "aws_iam_policy" "ingest" {

  name        = format("%s-%s", "amp-ingest", var.addon_context.eks_cluster_id)
  description = "Set up the permission policy that grants ingest (remote write) permissions for AMP workspace"
  policy      = data.aws_iam_policy_document.ingest.json
  tags        = var.addon_context.tags
}

module "irsa_amp_query" {
  source         = "../iam-role-for-serviceaccount"
  name           = join("-", ["irsa", local.name, var.addon_context.eks_cluster_id])
  namespace      = local.namespace
  serviceaccount = local.serviceaccount
  oidc_url       = var.addon_context.eks_oidc_issuer_url
  oidc_arn       = var.addon_context.eks_oidc_provider_arn
  policy_arns    = [aws_iam_policy.query.arn]
  environment    = var.environment
  tags           = var.addon_context.tags
}

resource "aws_iam_policy" "query" {

  name        = format("%s-%s", "amp-query", var.addon_context.eks_cluster_id)
  description = "Set up the permission policy that grants query permissions for AMP workspace"
  policy      = data.aws_iam_policy_document.query.json
  tags        = var.addon_context.tags
}