locals {
  vpc_config = {
    id              = data.aws_vpc.main.id,
    private_subnets = data.aws_subnets.private.ids,
    public_subnets  = data.aws_subnets.public.ids,
    cidr            = data.aws_vpc.main.cidr_block
  }
  cluster_name    = var.project_config.cluster_name
  cluster_version = var.project_config.cluster_version
  # environment            = "prod"
  # cloudtrail_bucket_name = "${var.project_config.name}-cloudtrail-bucket-${data.aws_caller_identity.current.account_id}"

  regular_eks_users = [
    for user in var.eks_users :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}"
      username = "${user}"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    }
  ]

  /* assumed_role_eks_users = [
    for user in var.assumed_role_eks_users :
    {
      userarn  = "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/${user}"
      username = "${user}"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    }
  ] */

  #  map_users = concat(local.regular_eks_users, local.assumed_role_eks_users)

  azs = [
    data.aws_availability_zones.azs.names[0],
    data.aws_availability_zones.azs.names[1]
  ]

  node_group_name = "managed-nodegroup"
}
