# Create repository
resource "github_repository" "quarkus_dashbuilder" {
  name                   = "quarkus-dashbuilder"
  description            = "Enable creation of dashboards using local and remote data with DashBuilder"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["dashbuilder", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_dashbuilder" {
  name                      = "quarkiverse-dashbuilder"
  description               = "dashbuilder team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_dashbuilder" {
  team_id    = github_team.quarkus_dashbuilder.id
  repository = github_repository.quarkus_dashbuilder.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_dashbuilder" {
  for_each = { for tm in ["jesuino"] : tm => tm }
  team_id  = github_team.quarkus_dashbuilder.id
  username = each.value
  role     = "maintainer"
}
