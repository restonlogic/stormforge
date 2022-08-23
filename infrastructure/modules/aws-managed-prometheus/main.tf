resource "aws_prometheus_workspace" "amp_workspace" {
  alias = local.amazon_prometheus_workspace_alias
}


resource "aws_prometheus_rule_group_namespace" "amp_rule_group" {
  name         = "rules"
  workspace_id = aws_prometheus_workspace.amp_workspace.id
  data         = <<EOF
groups:
  - name: test
    rules:
    - record: metric:recording_rule
      expr: avg(rate(container_cpu_usage_seconds_total[5m]))
  - name: alert-test
    rules:
    - alert: metric:alerting_rule
      expr: avg(rate(container_cpu_usage_seconds_total[5m])) > 0
      for: 2m
EOF
}

resource "aws_prometheus_alert_manager_definition" "amp_alert" {
  workspace_id = aws_prometheus_workspace.amp_workspace.id
  definition   = <<EOF
alertmanager_config: |
  route:
    receiver: 'default'
  receivers:
    - name: 'default'
EOF
}