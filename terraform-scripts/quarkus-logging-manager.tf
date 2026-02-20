# Create repository
resource "github_repository" "quarkus_logging_manager" {
  name                   = "quarkus-logging-manager"
  description            = "Quarkus extension that allows you to view the log online and change log levels using a UI"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_discussions        = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_logging_manager" {
  name                      = "quarkiverse-logging-manager"
  description               = "Quarkiverse team for the logging-manager extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_logging_manager" {
  team_id    = github_team.quarkus_logging_manager.id
  repository = github_repository.quarkus_logging_manager.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_logging_manager" {
  for_each = { for tm in ["oscarfh", "phillip-kruger", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_logging_manager.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_logging_manager" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_logging_manager.name
}
