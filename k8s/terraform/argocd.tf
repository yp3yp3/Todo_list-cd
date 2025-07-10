resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace  = "argocd"
  create_namespace = true

  set = [
    {
    name  = "server.ingress.enabled"
    value = "true"
  },
  {
    name  = "server.ingress.ingressClassName"
    value = "nginx" # Ensure this matches your ingress controller class
  },

   {
    name  = "server.ingress.hostname"
    value = "argocd.yp3yp3.site" # Replace with your actual domain
  },
  {
      name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/backend-protocol"
      value = "HTTPS"
  }
  ]
  depends_on = [module.eks]
}