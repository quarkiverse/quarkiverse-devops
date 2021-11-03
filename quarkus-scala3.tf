# Create repository
resource "github_repository" "quarkus_scala" {
  name                   = "quarkus-scala3"
  description            = "Quarkus Extension to support Scala 3"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_scala" {
  name                      = "quarkiverse-scala"
  description               = "Quarkiverse team for the scala extension"
  create_default_maintainer = false
  privacy                   = "closed"
}

# Add team to repository
resource "github_team_repository" "quarkus_scala" {
  team_id    = github_team.quarkus_scala.id
  repository = github_repository.quarkus_scala.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_scala" {
  for_each = { for tm in ["GavinRay97"] : tm => tm }
  team_id  = github_team.quarkus_scala.id
  username = each.value
  role     = "maintainer"
}
