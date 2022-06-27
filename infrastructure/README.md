# Structure

This entire module has been seperated into different .tf files for ease of reading and allowing for portability to other projects. 

For additional information on how to use the EKS Blueprint module used in [./kubernetes_addons.tf](https://github.com/restonlogic/stormforge/blob/main/infrastructure/kubernetes_addons.tf), go to https://aws-ia.github.io/terraform-aws-eks-blueprints/v4.2.1/add-ons/ for documentation and list of supported Add-ons. 

# /yamls

The [./yamls](https://github.com/restonlogic/stormforge/tree/main/infrastructure/yamls) folder contains helm values for ArgoCD. Included are the values for the vault plugin & repo secret configurations. 