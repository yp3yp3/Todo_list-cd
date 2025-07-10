provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  
}
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
data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}
output "argocd_admin_password" {
  value     = data.kubernetes_secret.argocd_admin_password.data["password"]
  sensitive = true
  
}

resource "kubectl_manifest" "root_app" {
  yaml_body = file("../argo/root-app.yaml")
}