# Create repository
resource "github_repository" "quarkus_helm" {
  name                   = "quarkus-helm"
  description            = "Quarkus Extension to generate the Helm artifacts"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_helm" {
  name                      = "quarkiverse-helm"
  description               = "Quarkiverse Helm team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_helm" {
  team_id    = github_team.quarkus_helm.id
  repository = github_repository.quarkus_helm.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_helm" {
  for_each = { for tm in ["Sgitario"] : tm => tm }
  team_id  = github_team.quarkus_helm.id
  username = each.value
  role     = "maintainer"
}