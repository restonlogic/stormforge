dns_domain              = "avar-demo.com"
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

versions_config = {
  # karpenter         = "0.13.1"
  aws_lb_controller = "1.4.2"
  # external_dns      = "6.5.5"
  # jenkins           = "3.12.1"
  # sonarqube         = "3.0.0"
  # consul            = "0.43.0"
}

secrets = {
  stormforge = "/stormforge/optimize-secrets"
}

ed-api-key = "9f92bba5-74c0-4a99-88c5-933e1c7a337a"

