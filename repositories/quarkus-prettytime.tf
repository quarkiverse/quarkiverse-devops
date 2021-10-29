# Create repository
resource "github_repository" "quarkus_prettytime" {
  name                   = "quarkus-prettytime"
  description            = "Quarkus Extension for Social Style Date and Time Formatting"
  delete_branch_on_merge = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_prettytime" {
  name                      = "quarkiverse-prettytime"
  description               = "Quarkiverse team for the Prettytime extension"
  create_default_maintainer = false
  privacy                   = "closed"
}

# Add team to repository
resource "github_team_repository" "quarkus_prettytime" {
  team_id    = github_team.quarkus_prettytime.id
  repository = github_repository.quarkus_prettytime.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_prettytime" {
  for_each = { for tm in ["gastaldi"] : tm => tm }
  team_id  = github_team.quarkus_prettytime.id
  username = each.value
  role     = "maintainer"
}
