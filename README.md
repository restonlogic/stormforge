# Terraform

The terraform module contained under [/infrastructure/.](https://github.com/restonlogic/stormforge/tree/main/infrastructure) will deploy a VPC, EKS control plane + 3 nodes, and Kubernetes addons which include Prometheus and ArgoCD. 

Copy and paste the following variables into a tfvars before running <mark>terraform apply</mark> 

```
git_config = {
  username     = "" 
  access_token = ""
  primary_repo = "https://github.com/restonlogic/stormforge" #Change to name of repo that contains your argocd applications. 
}
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#Required by ArgoCD vault plugin, for accessing awssecretsmanager. 
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
aws_credentials = { 
  access_key_id = ""
  secret_access_key = "
}

```

