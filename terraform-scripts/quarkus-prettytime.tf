# Create repository
resource "github_repository" "quarkus_prettytime" {
  name                   = "quarkus-prettytime"
  description            = "Quarkus Extension for Social Style Date and Time Formatting"
  allow_update_branch    = true
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
resource "github_team" "quarkus_prettytime" {
  name                      = "quarkiverse-prettytime"
  description               = "Quarkiverse team for the Prettytime extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_prettytime" {
  team_id    = github_team.quarkus_prettytime.id
  repository = github_repository.quarkus_prettytime.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_prettytime" {
  for_each = { for tm in ["gastaldi", "quarkiversebot"] : tm => tm }
  team_id  = github_team.quarkus_prettytime.id
  username = each.value
  role     = "maintainer"
}

