# output "configure_kubectl" {
#   description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
#   value       = module.eks_blueprints.configure_kubectl
# }

#terraform output -raw argocd_password
output "argocd_password" {
  description = "run 'terraform output -raw argocd_password' to get the password"
  value       = random_password.argocd_admin_password.result
  sensitive   = true
}