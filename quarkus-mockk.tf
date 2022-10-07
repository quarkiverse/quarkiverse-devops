# Create repository
resource "github_repository" "quarkus_mockk" {
  name                   = "quarkus-mockk"
  description            = "Mockk Quarkus Extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  has_projects           = true
  topics                 = ["quarkus-extension"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_mockk" {
  name                      = "quarkiverse-mockk"
  description               = "Quarkiverse team for the mockk extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mockk" {
  team_id    = github_team.quarkus_mockk.id
  repository = github_repository.quarkus_mockk.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mockk" {
  for_each = { for tm in ["glefloch"] : tm => tm }
  team_id  = github_team.quarkus_mockk.id
  username = each.value
  role     = "maintainer"
}
