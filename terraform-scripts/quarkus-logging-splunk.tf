# Create repository
resource "github_repository" "quarkus_logging_splunk" {
  name                   = "quarkus-logging-splunk"
  description            = "Quarkus extension to be able to send logs to a Splunk HTTP Event Collector"
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
resource "github_team" "quarkus_logging_splunk" {
  name                      = "quarkiverse-logging-splunk"
  description               = "Quarkiverse team for the logging_splunk extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_logging_splunk" {
  team_id    = github_team.quarkus_logging_splunk.id
  repository = github_repository.quarkus_logging_splunk.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_logging_splunk" {
  for_each = { for tm in ["vietk", "rquinio1A", "edeweerd1A", "flazarus1A", "lmartella1"] : tm => tm }
  team_id  = github_team.quarkus_logging_splunk.id
  username = each.value
  role     = "maintainer"
}
