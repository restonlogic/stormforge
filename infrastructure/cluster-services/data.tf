data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# data "aws_eks_cluster" "eks" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.cluster_id
# }

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_config.name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  tags = {
    Type = "${var.project_config.name} Private Subnet"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  tags = {
    Type = "${var.project_config.name} Public Subnet"
  }
}

