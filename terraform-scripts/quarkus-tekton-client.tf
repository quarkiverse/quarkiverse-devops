# Create repository
resource "github_repository" "quarkus_tekton_client" {
  name                   = "quarkus-tekton-client"
  description            = "Quarkus Tekton Client extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_tekton_client" {
  name                      = "quarkiverse-tekton-client"
  description               = "Quarkiverse team for the tekton-client extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_tekton_client" {
  team_id    = github_team.quarkus_tekton_client.id
  repository = github_repository.quarkus_tekton_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_tekton_client" {
  for_each = { for tm in ["goldmann"] : tm => tm }
  team_id  = github_team.quarkus_tekton_client.id
  username = each.value
  role     = "maintainer"
}
