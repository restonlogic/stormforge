module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.vpc_config.name
  cidr = var.vpc_config.cidr

  azs = [
    data.aws_availability_zones.azs.names[0],
    data.aws_availability_zones.azs.names[1]
  ]

  public_subnets  = [
    cidrsubnet(var.vpc_config.cidr, 3, 2),
    cidrsubnet(var.vpc_config.cidr, 3, 4)
  ]
  
  private_subnets = [
    cidrsubnet(var.vpc_config.cidr, 3, 1),
    cidrsubnet(var.vpc_config.cidr, 3, 3)
  ]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${var.project_config.name}-ACL" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${var.project_config.name}-route_table" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${var.project_config.name}-security_group" }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.project_config.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                           = "1"
    "Type"                                             = "${var.project_config.name} Public Subnet"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.project_config.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                  = "1"
    "Type"                                             = "${var.project_config.name} Private Subnet"
  }

  tags = {
    Name = var.vpc_config.name
    Project = var.project_config.name
  }
}
