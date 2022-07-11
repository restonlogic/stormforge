# Terraform

The terraform module contained under [/infrastructure/.](https://github.com/restonlogic/stormforge/tree/main/infrastructure) will deploy a VPC, EKS control plane + 3 nodes, and Kubernetes addons which include Prometheus and ArgoCD+vault_plugin. 

Copy and paste the following variables into a tfvars before running <mark>terraform apply</mark> 

```
git_config = {
  username     = "" 
  access_token = ""
  primary_repo = "https://github.com/restonlogic/stormforge" #Change to name of repo that contains your argocd applications. 
}

```

# IGNORE the ./applications FOLDER

The application folder is not currently being used. All resources are being deployed via Terraform. 