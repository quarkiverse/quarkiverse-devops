# Create repository
resource "github_repository" "quarkus_freemarker" {
  name                   = "quarkus-freemarker"
  description            = "Quarkus Freemarker Extension"
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
resource "github_team" "quarkus_freemarker" {
  name                      = "quarkiverse-freemarker"
  description               = "Quarkiverse team for the freemarker extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_freemarker" {
  team_id    = github_team.quarkus_freemarker.id
  repository = github_repository.quarkus_freemarker.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_freemarker" {
  for_each = { for tm in ["vsevel"] : tm => tm }
  team_id  = github_team.quarkus_freemarker.id
  username = each.value
  role     = "maintainer"
}
