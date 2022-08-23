resource "kubernetes_namespace" "edgedelta_ns" {
  metadata {
    name = "edgedelta"
  }
}

resource "kubernetes_secret" "edgedelta_secret" {
  metadata {
    name = "ed-api-key"
    namespace = "edgedelta"
  }

  data = {
    ed-api-key = var.ed-api-key
  }

  depends_on = [
    kubernetes_namespace.edgedelta_ns
  ]
}

resource "kubectl_manifest" "edgedelta_DS" {
  depends_on = [
    kubernetes_namespace.edgedelta_ns
  ]

  yaml_body = <<YAML
apiVersion: apps/v1
kind: DaemonSet
metadata: 
  name: edgedelta
  namespace: edgedelta
  annotations:
    prometheus.io/scrape: "true"
  labels:
    k8s-app: edgedelta-logging
    version: v1
    kubernetes.io/cluster-service: "true"
spec:
  selector:
    matchLabels:
      k8s-app: edgedelta-logging
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  template:
    metadata:
      labels:
        k8s-app: edgedelta-logging
        version: v1
        kubernetes.io/cluster-service: "true"
    spec:
      serviceAccountName: edgedelta
      containers:
      - name: edgedelta-agent
        image: gcr.io/edgedelta/agent:v0.1.38
        env:
          - name: ED_API_KEY
            valueFrom:
              # kubectl create secret generic ed-api-key \
              #   --namespace=edgedelta \
              #   --from-literal=ed-api-key="2c7a5780-..."
              secretKeyRef:
                key: ed-api-key
                name: ed-api-key
          # Uncomment if proxy setup needed
          # More details: https://github.com/golang/net/blob/master/http/httpproxy/proxy.go#L27
          # - name:  HTTP_PROXY
          #   value: my.proxy.com
          # - name:  NO_PROXY
          #   value: skip.proxy.com
          # pass node hostname to agent
          - name: ED_HOST_OVERRIDE
            valueFrom:
              fieldRef:
                fieldPath: spec.nodeName
          - name: ED_LEADER_ELECTION_ENABLED
            value: "1"
        command:
          - /edgedelta/edgedelta
        resources:
          limits:
            memory: 2048Mi
          requests:
            cpu: 200m
            memory: 256Mi
        volumeMounts:
          - name: varlog
            mountPath: /var/log
            readOnly: true
          - name: varlibdockercontainers
            # Some Kubernetes distributions may use /docker/containers instead of standard /var/lib/docker/containers
            # Update mountPath to match the actual container log folder path
            mountPath: /var/lib/docker/containers
            readOnly: true
        # Required for OpenShift or SELinux enabled K8s clusters
        # securityContext:
        #   runAsUser: 0
        #   privileged: true
      imagePullSecrets:
        - name: regcred
      terminationGracePeriodSeconds: 10
      volumes:
        - name: varlog
          hostPath:
            path: /var/log
        - name: varlibdockercontainers
          hostPath:
            # Update path below if you changed volumeMounts varlibdockercontainers mountPath
            path: /var/lib/docker/containers
YAML
}

resource "kubectl_manifest" "edgedelta_CRB" {
  depends_on = [
    kubernetes_namespace.edgedelta_ns
  ]
  
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: edgedelta
subjects:
- kind: ServiceAccount
  name: edgedelta
  namespace: edgedelta
roleRef:
  kind: ClusterRole
  name: edgedelta
  apiGroup: rbac.authorization.k8s.io
YAML
}

resource "kubectl_manifest" "edgedelta_CR" {
  depends_on = [
    kubernetes_namespace.edgedelta_ns
  ]
  
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: edgedelta
  labels:
    k8s-app: edgedelta-logging
rules:
- apiGroups: [""] # "" indicates the core API group
  resources:
  - namespaces
  - pods
  - events
  - nodes
  verbs:
  - get
  - watch
  - list
- apiGroups: ["coordination.k8s.io"]
  resources:
  - leases
  verbs:
  - get
  - list
  - watch
  - create
  - update
  - patch
  - delete
- apiGroups: ["metrics.k8s.io"]
  resources:
  - pods
  - nodes
  verbs:
  - get
  - list
  - watch
YAML
}

resource "kubectl_manifest" "edgedelta_SA" {
  depends_on = [
    kubernetes_namespace.edgedelta_ns
  ]
  
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: edgedelta
  namespace: edgedelta
  labels:
    k8s-app: edgedelta-logging
YAML
}
