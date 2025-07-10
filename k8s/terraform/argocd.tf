resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace  = "argocd"
  create_namespace = true

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
set {
    name  = "server.ingress.ingressClassName"
    value = "nginx" # Ensure this matches your ingress controller class
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = "argocd.yp3yp3.site" # Replace with your actual domain
  }

  depends_on = [module.eks]
}