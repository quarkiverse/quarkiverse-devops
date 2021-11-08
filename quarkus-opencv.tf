# Create repository
resource "github_repository" "quarkus_opencv" {
  name                   = "quarkus-opencv"
  description            = "OpenCV extension for Quarkus"
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
resource "github_team" "quarkus_opencv" {
  name                      = "quarkiverse-opencv"
  description               = "Quarkiverse team for the opencv extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_opencv" {
  team_id    = github_team.quarkus_opencv.id
  repository = github_repository.quarkus_opencv.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_opencv" {
  for_each = { for tm in ["gsmet"] : tm => tm }
  team_id  = github_team.quarkus_opencv.id
  username = each.value
  role     = "maintainer"
}
