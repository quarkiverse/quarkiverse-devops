# Create repository
resource "github_repository" "quarkus_logging_logback" {
  name                   = "quarkus-logging-logback"
  description            = "Quarkus Logback extension"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_logging_logback" {
  name                      = "quarkiverse-logging-logback"
  description               = "Quarkiverse team for the logback Logging extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_logging_logback" {
  team_id    = github_team.quarkus_logging_logback.id
  repository = github_repository.quarkus_logging_logback.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_logging_logback" {
  for_each = { for tm in ["stuartwdouglas"] : tm => tm }
  team_id  = github_team.quarkus_logging_logback.id
  username = each.value
  role     = "maintainer"
}
