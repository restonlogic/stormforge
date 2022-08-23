resource "aws_iam_policy" "alb-controller" {
  name        = "${var.project_config.name}-alb-controller-policy"
  description = "${var.project_config.name}-alb-controller-policy"
  policy      = file("${path.module}/../policies/alb-policy.json")
}

data "aws_iam_policy_document" "alb-controller_service_account_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(jsondecode(data.aws_secretsmanager_secret_version.eks_secrets.secret_string)["eks_oidc_issuer_url"], "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(jsondecode(data.aws_secretsmanager_secret_version.eks_secrets.secret_string)["eks_oidc_issuer_url"], "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [jsondecode(data.aws_secretsmanager_secret_version.eks_secrets.secret_string)["eks_oidc_issuer_arn"]]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "alb-controller-account-role" {
  assume_role_policy = data.aws_iam_policy_document.alb-controller_service_account_assume_role_policy.json
  name               = "${var.project_config.name}-alb-controller"
}

resource "aws_iam_role_policy_attachment" "alb-controller_policy_attach" {
  role       = aws_iam_role.alb-controller-account-role.name
  policy_arn = aws_iam_policy.alb-controller.arn
}

resource "kubernetes_service_account" "alb-controller-service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb-controller-account-role.arn
    }
  }
}

resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.4.4"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = "storm-demo"
    type  = "string"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller "
    type  = "string"
  }
}




# data "kubectl_path_documents" "alb-controllers" {
#   pattern = "${path.module}/../yamls/aws-load-balancer.yaml"
#   vars = {
#     CLUSTERNAME = "storm-demo"
#   }
#   depends_on = [kubernetes_service_account.alb-controller-service-account]
# }

# resource "kubectl_manifest" "alb-controllers" {
#   count     = 12
#   yaml_body = element(data.kubectl_path_documents.alb-controllers.documents, count.index)

#   depends_on = [kubernetes_service_account.alb-controller-service-account]
# }

# data "kubectl_path_documents" "alb-ingressclass" {
#   pattern = "${path.module}/../yamls/alb-ingress.yaml"
  
#   depends_on = [kubectl_manifest.alb-controllers]  
# }

# resource "kubectl_manifest" "alb-ingressclass" {
#   count     = 2
#   yaml_body = element(data.kubectl_path_documents.alb-ingressclass.documents, count.index)

#   depends_on = [kubectl_manifest.alb-controllers]
# }