data "github_repository" "flux" {
  full_name = "${var.github_owner}/${var.github_repository}"
}

# ==========================================
# Add deploy key to GitHub repository
# ==========================================

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "flux" {
  title      = "Flux"
  repository = data.github_repository.flux.name
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}

# ==========================================
# Bootstrap KinD cluster
# ==========================================

resource "flux_bootstrap_git" "main" {
  depends_on = [github_repository_deploy_key.flux]

  embedded_manifests = true
  path               = "./flux"
}
