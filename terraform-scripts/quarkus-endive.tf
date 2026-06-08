# Create repository
resource "github_repository" "quarkus_chicory" {
  name                   = "quarkus-endive"
  description            = "A Quarkus extension to easily integrate Endive(WASM runtime) in your applications"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-endive/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["wasm", "endive", "sandbox", "quarkus-extension"]
}

resource "github_repository_vulnerability_alerts" "quarkus_chicory" {
  repository = github_repository.quarkus_chicory.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_chicory" {
  name           = "quarkiverse-endive"
  description    = "endive team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_chicory" {
  team_id    = github_team.quarkus_chicory.id
  repository = github_repository.quarkus_chicory.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_chicory" {
  for_each = { for tm in ["fabiobrz", "andreaTP"] : tm => tm }
  team_id  = github_team.quarkus_chicory.id
  username = each.value
  role     = "maintainer"
}
