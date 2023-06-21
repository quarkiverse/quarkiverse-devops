# Create repository
resource "github_repository" "quarkus_togglz" {
  name                   = "quarkus-togglz"
  description            = "Togglz is an implementation of the Feature Toggles pattern for Java"
  homepage_url           = "https://www.togglz.org/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_togglz" {
  name                      = "quarkiverse-togglz"
  description               = "togglz team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_togglz" {
  team_id    = github_team.quarkus_togglz.id
  repository = github_repository.quarkus_togglz.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_togglz" {
  for_each = { for tm in ["bennetelli"] : tm => tm }
  team_id  = github_team.quarkus_togglz.id
  username = each.value
  role     = "maintainer"
}
