# Create repository
resource "github_repository" "quarkus_minio" {
  name                   = "quarkus-minio"
  description            = "Minio (https://min.io) Client Quarkus Extension"
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
  create_default_maintainer = false
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
