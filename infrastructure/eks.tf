#---------------------------------------------------------------
# EKS Blueprints
#---------------------------------------------------------------
module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints"

  cluster_name    = local.name
  cluster_version = local.version

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  managed_node_groups = {
    mg_5x = {
      node_group_name = "managed-nodegroup"
      instance_types  = ["m5.xlarge"]
      subnet_ids      = module.vpc.private_subnets

      desired_size = 3
      max_size     = 10
      min_size     = 3
    }
  }

  tags = local.tags
}
