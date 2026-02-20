# Create repository
resource "github_repository" "quarkus_argocd" {
  name                   = "quarkus-argocd"
  description            = "An ArgoCD extension for Quarkus"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-argocd/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_argocd" {
  name                      = "quarkiverse-argocd"
  description               = "argocd team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_argocd" {
  team_id    = github_team.quarkus_argocd.id
  repository = github_repository.quarkus_argocd.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_argocd" {
  for_each = { for tm in ["iocanel", "aureamunoz", "cmoulliard"] : tm => tm }
  team_id  = github_team.quarkus_argocd.id
  username = each.value
  role     = "maintainer"
}
