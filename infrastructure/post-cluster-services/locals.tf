# locals {
#   vpc_config = {
#     id               = data.aws_vpc.main.id,
#     private_subnets  = data.aws_subnets.private.ids,
#     public_subnets   = data.aws_subnets.public.ids,
#     cidr             = data.aws_vpc.main.cidr_block
#   }

#   azs = [
#     data.aws_availability_zones.azs.names[0],
#     data.aws_availability_zones.azs.names[1]
#   ]

#   node_group_name = "managed-nodegroup"

# }
