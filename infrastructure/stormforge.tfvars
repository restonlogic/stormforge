dns_domain             = "avar-demo.com"
acm_certificate_domain = "*.avar-demo.com"

vpc_config = {
  name   = "stormforge-vpc",
  cidr   = "10.0.0.0/16"
  region = "us-east-2"
}

project_config = {
  name            = "stormforge"
  cluster_version = "1.23"
  cluster_name    = "storm-demo"
}

optimize = {
  live_helm_version = "0.7.4"
  pro_helm_version  = "2.1.7"
}

tags = {
  Project = "Stormforge"
}

versions_config = {
  aws_lb_controller = "1.4.2"
}

secrets = {
  stormforge = "/stormforge/optimize-secrets"
}

ed-api-key = "9f92bba5-74c0-4a99-88c5-933e1c7a337a"

eks_users = ["tanvir.ahmed", "madhu.joshi"]
