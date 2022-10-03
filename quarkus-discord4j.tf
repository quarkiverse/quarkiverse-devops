# Create repository
resource "github_repository" "quarkus_discord4j" {
  name                   = "quarkus-discord4j"
  description            = "A JVM-based REST/WS wrapper for the official Discord Bot API, written in Java"
  homepage_url           = "https://discord4j.com/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "discord"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_discord4j" {
  name                      = "quarkiverse-discord4j"
  description               = "discord4j team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_discord4j" {
  team_id    = github_team.quarkus_discord4j.id
  repository = github_repository.quarkus_discord4j.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_discord4j" {
  for_each = { for tm in ["cameronprater"] : tm => tm }
  team_id  = github_team.quarkus_discord4j.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_discord4j" {
  for_each = { for app in [local.applications.stale] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_discord4j.name
}