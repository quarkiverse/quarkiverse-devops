# Create repository
resource "github_repository" "quarkus_logging_json" {
  name                   = "quarkus-logging-json"
  description            = "Quarkus logging extension outputting the logging in json."
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["json", "logging", "hacktoberfest", "quarkus", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_logging_json" {
  name                      = "quarkiverse-logging-json"
  description               = "Quarkiverse team for the logging-json extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_logging_json" {
  team_id    = github_team.quarkus_logging_json.id
  repository = github_repository.quarkus_logging_json.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_logging_json" {
  for_each = { for tm in ["SlyngDK"] : tm => tm }
  team_id  = github_team.quarkus_logging_json.id
  username = each.value
  role     = "maintainer"
}
