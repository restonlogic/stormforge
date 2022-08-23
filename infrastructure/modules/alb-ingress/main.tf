locals {
  alb_ingress = {
    name            = lookup(var.helm, "name", "aws-alb-ingress-controller")
    chart           = lookup(var.helm, "chart", "aws-alb-ingress-controller")
    chart_version   = lookup(var.helm, "version", null)
    repository      = lookup(var.helm, "repository", "https://charts.helm.sh/incubator")
    namespace       = local.namespace
    cleanup_on_fail = lookup(var.helm, "cleanup_on_fail", true)
    enabled         = true
    default_values  = local.alb_ingress_values
  }

  alb_ingress_values = <<-VALUES
    autoDiscoverAwsRegion:  true
    autoDiscoverAwsVpcID: true
    clusterName: "${var.cluster_name}"
    rbac.serviceAccount.name: "${local.serviceaccount}"
    rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn: "${module.irsa.arn}"
    serviceAccount:
      create: false
      annotations: {}
      name: "${local.serviceaccount}"
      automountServiceAccountToken: true
VALUES

  #   nlb_ingress = {
  #     name            = lookup(var.helm, "name", "aws-alb-ingress-controller")
  #     chart           = lookup(var.helm, "chart", "aws-alb-ingress-controller")
  #     chart_version   = lookup(var.helm, "version", null)
  #     repository      = lookup(var.helm, "repository", "https://charts.helm.sh/incubator")
  #     namespace       = local.namespace
  #     cleanup_on_fail = lookup(var.helm, "cleanup_on_fail", true)
  #     enabled         = true
  #     default_values  = local.nlb_ingress_values
  #   }

  #   nlb_ingress_values = <<-VALUES
  #     autoDiscoverAwsRegion:  true
  #     autoDiscoverAwsVpcID: true
  #     clusterName: "${var.cluster_name}"
  #     rbac.serviceAccount.name: "${local.serviceaccount}"
  #     rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn: "${module.irsa.arn}"
  #     ingress-class: nlb
  # VALUES

}

module "albingress_helm" {
  source      = "../helm-deploy"
  helm_config = local.alb_ingress
}


# module "nlbingress_helm" {
#   source      = "../helm_deploy"

#   providers = {
#     helm.mgmt = helm.mgmt
#     helm.dev  = helm.dev
#     helm.qa   = helm.qa
#     helm.prod = helm.prod
#   }

#   helm_config = local.nlb_ingress
#   environment = var.environment
# }