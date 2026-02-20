# Create repository
resource "github_repository" "quarkus_rsocket" {
  name                   = "quarkus-rsocket"
  description            = "Quarkus RSocket extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_rsocket" {
  name                      = "quarkiverse-rsocket"
  description               = "Quarkiverse team for the rsocket extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_rsocket" {
  team_id    = github_team.quarkus_rsocket.id
  repository = github_repository.quarkus_rsocket.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_rsocket" {
  for_each = { for tm in ["dufoli"] : tm => tm }
  team_id  = github_team.quarkus_rsocket.id
  username = each.value
  role     = "maintainer"
}
