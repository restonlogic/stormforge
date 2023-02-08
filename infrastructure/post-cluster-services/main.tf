#---------------------------------------------------------------
# Randomized password for ArgoCD dashboard
#---------------------------------------------------------------
# resource "random_password" "argocd_admin_password" {
#   length  = 16
#   special = false
# }

resource "kubernetes_namespace" "stormforge-system" {
  metadata {
    name = "stormforge-system"
  }
}

#---------------------------------------------------------------
# EKS Blueprints Kubernetes Addons
#---------------------------------------------------------------
module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"

  eks_cluster_id       = data.aws_eks_cluster.eks.id
  eks_cluster_endpoint = data.aws_eks_cluster.eks.endpoint
  eks_oidc_provider    = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
  eks_cluster_version  = data.aws_eks_cluster.eks.version

  #--------------------------------------------------------------#
  # ArgoCD Configurations                                        #
  #--------------------------------------------------------------#
  enable_argocd         = false
  argocd_manage_add_ons = false # Indicates that ArgoCD is responsible for managing/deploying add-ons
  # argocd_helm_config = {
  #   name             = "argo-cd"
  #   chart            = "argo-cd"
  #   repository       = "https://argoproj.github.io/argo-helm"
  #   version          = "4.9.4"
  #   namespace        = "argocd"
  #   timeout          = "1200"
  #   create_namespace = true
  #   values = [
  #     templatefile("${path.module}/../yamls/argocd-vaultplugin-values.yaml", {
  #       argocd_admin_password = bcrypt(random_password.argocd_admin_password.result),
  #       primary_repo_url      = var.git_repo,
  #       git_username          = var.git_user,
  #       git_access_token      = var.git_token
  #     })
  #   ]
  # }
  # argocd_applications = {
  #   sample-application = {
  #         namespace          = "argocd"
  #         path               = "applications"
  #         repo_url           = var.git_repo
  #         target_revision    = "HEAD"
  #         destination        = "https://kubernetes.default.svc"
  #         project            = "default"
  #         add_on_application = false # Indicates the root add-on application.
  #         values = {
  #           syncPolicy = "automated"
  #         }
  #       }
  # }

  #---------------------------------------------------------------
  # Prometheus Configurations
  #---------------------------------------------------------------
  enable_prometheus = false
  # prometheus_helm_config = {
  #   name       = "prometheus"                                         # (Required) Release name.
  #   repository = "https://prometheus-community.github.io/helm-charts" # (Optional) Repository URL where to locate the requested chart.
  #   chart      = "prometheus"                                         # (Required) Chart name to be installed.
  #   version    = "19.3.3"                                             # (Optional) Specify the exact chart version to install. If this is not specified, it defaults to the version set within default_helm_config: https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/modules/kubernetes-addons/prometheus/locals.tf
  #   namespace  = "monitoring"                                         # (Optional) The namespace to install the release into.
  #   # values = [templatefile("${path.module}/prometheus-values.yaml", {
  #   #   operating_system = "linux"
  #   # })]
  # }

  enable_amazon_eks_aws_ebs_csi_driver = true # default is false
  #Optional
  amazon_eks_aws_ebs_csi_driver_config = {
    addon_name               = "aws-ebs-csi-driver"
    addon_version            = "v1.15.0-eksbuild.1"
    service_account          = "ebs-csi-controller-sa"
    resolve_conflicts        = "OVERWRITE"
    namespace                = "kube-system"
    additional_iam_policies  = []
    service_account_role_arn = ""
    tags                     = {}
  }

  #---------------------------------------------------------------
  # ALB Configurations
  #---------------------------------------------------------------
  # enable_aws_load_balancer_controller = true
  # aws_load_balancer_controller_helm_config = {
  #   version = var.versions_config.aws_lb_controller
  # }

  #---------------------------------------------------------------
  # External DNS Configurations
  #---------------------------------------------------------------

  # enable_external_dns = true
  # dns_domain   = var.dns_domain

  #---------------------------------------------------------------

  tags = var.tags

}



#---------------------------------------------------------------
# Possible Kubernetes Addons
#---------------------------------------------------------------
#   # Add-ons
#   enable_aws_for_fluentbit  = true
#   enable_cert_manager       = true
#   enable_cluster_autoscaler = true
#   enable_karpenter          = true
#   enable_keda               = true
#   enable_metrics_server     = true
#   enable_prometheus         = true
#   enable_traefik            = true
#   enable_vpa                = true
#   enable_yunikorn           = true
#   enable_argo_rollouts      = true
#   enable_argocd             = true



#---------------------------------------------------------------
# Secret for ArgoCD vault plugin
#---------------------------------------------------------------
# resource "kubernetes_secret_v1" "example" {
#   metadata {
#     name      = "vault-configuration"
#     namespace = "argocd"
#   }

#   data = {
#     AVP_TYPE              = "awssecretsmanager"
#     AWS_REGION            = local.region
#     AWS_ACCESS_KEY_ID     = var.aws_credentials.access_key_id
#     AWS_SECRET_ACCESS_KEY = var.aws_credentials.secret_access_key
#   }
# }

/* module "prometheus" {
  source = "../modules/prometheus"
} */
