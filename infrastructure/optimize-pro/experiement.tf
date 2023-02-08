
data "kubectl_path_documents" "postgres_yaml" {
  pattern    = "${path.module}/../yamls/experiements/optimize-pro/postgres/postgres.yaml"
  depends_on = [helm_release.optimize-pro]
}

resource "kubectl_manifest" "postgres_apply" {
  count     = length(data.kubectl_path_documents.postgres_yaml.documents)
  yaml_body = element(data.kubectl_path_documents.postgres_yaml.documents, count.index)
}

data "kubectl_path_documents" "experiments_yaml" {
  pattern    = "${path.module}/../yamls/experiements/optimize-pro/postgres/experiment.yaml"
  depends_on = [helm_release.optimize-pro]
}

resource "kubectl_manifest" "experiments_apply" {
  count     = length(data.kubectl_path_documents.experiments_yaml.documents)
  yaml_body = element(data.kubectl_path_documents.experiments_yaml.documents, count.index)
}

data "kubectl_path_documents" "experiment_rbac_yaml" {
  pattern    = "${path.module}/../yamls/experiements/optimize-pro/postgres/experiment-rbac.yaml"
  depends_on = [helm_release.optimize-pro]
}

resource "kubectl_manifest" "experiment_rbac_apply" {
  count     = length(data.kubectl_path_documents.experiment_rbac_yaml.documents)
  yaml_body = element(data.kubectl_path_documents.experiment_rbac_yaml.documents, count.index)
}
