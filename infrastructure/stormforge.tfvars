eks_cluster_domain      = "avar-demo.com"
acm_certificate_domain  = "*.avar-demo.com"

vpc_config = {
  name   = "stormforge-vpc",
  cidr   = "10.0.0.0/16"
  region = "us-east-2"
}

project_config = {
  name            = "stormforge"
  cluster_version = "1.21"
  cluster_name    = "storm-demo"
}

tags = {
  Project = "Stormforge"
}


secret = {
  name = "secret/stormforge"
}