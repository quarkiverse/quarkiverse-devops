# Create repository
resource "github_repository" "quarkus_logging_sentry" {
  name                   = "quarkus-logging-sentry"
  description            = "Quarkus extension for Sentry, a self-hosted or cloud-based error monitoring solution"
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
resource "github_team" "quarkus_logging_sentry" {
  name                      = "quarkiverse-logging-sentry"
  description               = "Quarkiverse team for the Sentry Logging extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_logging_sentry" {
  team_id    = github_team.quarkus_logging_sentry.id
  repository = github_repository.quarkus_logging_sentry.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_logging_sentry" {
  for_each = { for tm in ["gsmet", "ia3andy"] : tm => tm }
  team_id  = github_team.quarkus_logging_sentry.id
  username = each.value
  role     = "maintainer"
}
