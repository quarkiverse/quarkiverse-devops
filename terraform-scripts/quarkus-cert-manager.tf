# Create repository
resource "github_repository" "quarkus_cert_manager" {
  name                   = "quarkus-cert-manager"
  description            = "Cert-Manager is an operator that generates certificates and issuers in Kubernetes/OpenShift"
  homepage_url           = "https://dekorate.io/docs/cert-manager"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_cert_manager" {
  name                      = "quarkiverse-cert-manager"
  description               = "cert-manager team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_cert_manager" {
  team_id    = github_team.quarkus_cert_manager.id
  repository = github_repository.quarkus_cert_manager.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_cert_manager" {
  for_each = { for tm in ["Sgitario"] : tm => tm }
  team_id  = github_team.quarkus_cert_manager.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_cert_manager" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_cert_manager.name
}

