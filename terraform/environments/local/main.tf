module "monitoring_stack" {
  source = "../../modules/helm-release"

  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "default"
}
