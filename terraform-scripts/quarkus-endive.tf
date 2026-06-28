# Create repository
resource "github_repository" "quarkus_endive" {
  name                   = "quarkus-endive"
  description            = "A Quarkus extension to easily integrate Endive(WASM runtime) in your applications"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-endive/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["wasm", "endive", "sandbox", "quarkus-extension"]
}

resource "github_repository_vulnerability_alerts" "quarkus_endive" {
  repository = github_repository.quarkus_endive.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_endive" {
  name           = "quarkiverse-endive"
  description    = "endive team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_endive" {
  team_id    = github_team.quarkus_endive.id
  repository = github_repository.quarkus_endive.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_endive" {
  for_each = { for tm in ["fabiobrz", "andreaTP"] : tm => tm }
  team_id  = github_team.quarkus_endive.id
  username = each.value
  role     = "maintainer"
}
