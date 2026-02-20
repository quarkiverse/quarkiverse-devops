# Create repository
resource "github_repository" "quarkus_jsch" {
  name                   = "quarkus-jsch"
  description            = "Quarkus JSch extension"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_jsch" {
  name                      = "quarkiverse-jsch"
  description               = "Quarkiverse team for the JSch extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jsch" {
  team_id    = github_team.quarkus_jsch.id
  repository = github_repository.quarkus_jsch.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jsch" {
  for_each = { for tm in ["gastaldi"] : tm => tm }
  team_id  = github_team.quarkus_jsch.id
  username = each.value
  role     = "maintainer"
}
