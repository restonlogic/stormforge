locals {
  helm_defaults = {
    atomic                = false
    cleanup_on_fail       = false
    dependency_update     = false
    disable_crd_hooks     = false
    disable_webhooks      = false
    force_update          = false
    recreate_pods         = false
    render_subchart_notes = true
    replace               = false
    reset_values          = false
    reuse_values          = false
    skip_crds             = false
    timeout               = 3600
    verify                = false
    wait                  = true
    create_namespace      = false
    default_values        = ""
    extra_values          = ""
    repo_user             = ""
    repo_password         = ""
  }
  helm_config = merge(
    local.helm_defaults,
    var.helm_config
  )
}

resource "helm_release" "helm_mgmt" {
  repository            = local.helm_config["repository"]
  name                  = local.helm_config["name"]
  chart                 = local.helm_config["chart"]
  version               = local.helm_config["chart_version"]
  timeout               = local.helm_config["timeout"]
  force_update          = local.helm_config["force_update"]
  recreate_pods         = local.helm_config["recreate_pods"]
  wait                  = local.helm_config["wait"]
  atomic                = local.helm_config["atomic"]
  cleanup_on_fail       = local.helm_config["cleanup_on_fail"]
  dependency_update     = local.helm_config["dependency_update"]
  disable_crd_hooks     = local.helm_config["disable_crd_hooks"]
  disable_webhooks      = local.helm_config["disable_webhooks"]
  render_subchart_notes = local.helm_config["render_subchart_notes"]
  replace               = local.helm_config["replace"]
  reset_values          = local.helm_config["reset_values"]
  reuse_values          = local.helm_config["reuse_values"]
  skip_crds             = local.helm_config["skip_crds"]
  verify                = local.helm_config["verify"]
  repository_username   = local.helm_config["repo_user"]
  repository_password   = local.helm_config["repo_password"]
  values = [
    local.helm_config["default_values"],
    local.helm_config["extra_values"]
  ]
  namespace = local.helm_config["namespace"]
}
