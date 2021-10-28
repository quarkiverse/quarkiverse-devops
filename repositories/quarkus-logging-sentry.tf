# Create repository
resource "github_repository" "quarkus_logging_sentry" {
  name = "quarkus-logging-sentry"
  description = "Quarkus extension for Sentry, a self-hosted or cloud-based error monitoring solution"
  delete_branch_on_merge = true
  topics = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_logging_sentry" {
  name                      = "quarkiverse-logging-sentry"
  description               = "Quarkiverse team for the Sentry Logging extension"
  create_default_maintainer = false
}

# Add team to repository
resource "github_team_repository" "quarkus_logging_sentry" {
  team_id    = github_team.quarkus_logging_sentry.id
  repository = github_repository.quarkus_logging_sentry.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_logging_sentry" {
  for_each = { for tm in ["gsmet","ia3andy"] : tm => tm }
  team_id  = github_team.quarkus_logging_sentry.id
  username = each.value
  role = "maintainer"
}
