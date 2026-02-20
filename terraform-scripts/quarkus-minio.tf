# Create repository
resource "github_repository" "quarkus_minio" {
  name                   = "quarkus-minio"
  description            = "Minio (https://min.io) Client Quarkus Extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "hacktoberfest"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_minio" {
  name                      = "quarkiverse-minio"
  description               = "Quarkiverse team for the minio extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_minio" {
  team_id    = github_team.quarkus_minio.id
  repository = github_repository.quarkus_minio.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_minio" {
  for_each = { for tm in ["jtama"] : tm => tm }
  team_id  = github_team.quarkus_minio.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_minio" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_minio.name
}
