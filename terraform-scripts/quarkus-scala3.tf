# Create repository
resource "github_repository" "quarkus_scala3" {
  name                   = "quarkus-scala3"
  description            = "Quarkus Extension to support Scala 3"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

resource "github_repository_vulnerability_alerts" "quarkus_scala3" {
  repository = github_repository.quarkus_scala3.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_scala3" {
  name           = "quarkiverse-scala"
  description    = "Quarkiverse team for the scala extension"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_scala3" {
  team_id    = github_team.quarkus_scala3.id
  repository = github_repository.quarkus_scala3.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_scala3" {
  for_each = { for tm in ["GavinRay97"] : tm => tm }
  team_id  = github_team.quarkus_scala3.id
  username = each.value
  role     = "maintainer"
}
