# Create repository
resource "github_repository" "quarkus_logging_cloudwatch" {
  name                   = "quarkus-logging-cloudwatch"
  description            = "Quarkus Amazon CloudWatch extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["cloudwatch", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_logging_cloudwatch" {
  name                      = "quarkiverse-logging-cloudwatch"
  description               = "Quarkiverse team for the logging-cloudwatch extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_logging_cloudwatch" {
  team_id    = github_team.quarkus_logging_cloudwatch.id
  repository = github_repository.quarkus_logging_cloudwatch.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_logging_cloudwatch" {
  for_each = { for tm in ["pilhuhn", "bennetelli", "gwenneg"] : tm => tm }
  team_id  = github_team.quarkus_logging_cloudwatch.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_logging_cloudwatch" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_logging_cloudwatch.name
}
