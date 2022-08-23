resource "aws_iam_policy" "external_dns" {
  name        = "${var.project_config.name}-external-dns-policy"
  description = "${var.project_config.name}-external-dns-policy"
  policy      = file("${path.module}/../policies/sa-permissions.json")
}


data "aws_iam_policy_document" "external_dns_service_account_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(jsondecode(data.aws_secretsmanager_secret_version.eks_secrets.secret_string)["eks_oidc_issuer_url"], "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:external-dns"]
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

resource "aws_iam_role" "external-dns-account-role" {
  assume_role_policy = data.aws_iam_policy_document.external_dns_service_account_assume_role_policy.json
  name               = "${var.project_config.name}-external-dns"
}

resource "aws_iam_role_policy_attachment" "external_dns_account_policy_attach" {
  role       = aws_iam_role.external-dns-account-role.name
  policy_arn = aws_iam_policy.external_dns.arn
}

resource "kubernetes_service_account" "external-dns-service-account" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external-dns-account-role.arn
    }
  }
}

data "kubectl_path_documents" "external_dns" {
  pattern = "${path.module}/../yamls/external-dns.yaml"
  vars = {
    DNS_DOMAIN = var.dns_domain
    NAMESPACE  = "kube-system"
  }
  depends_on = [kubernetes_service_account.external-dns-service-account]
}

resource "kubectl_manifest" "external_dns" {
  count     = 3
  yaml_body = element(data.kubectl_path_documents.external_dns.documents, count.index)

  depends_on = [kubernetes_service_account.external-dns-service-account]
}

