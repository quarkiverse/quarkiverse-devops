# Create repository
resource "github_repository" "quarkus_antora" {
  name                   = "quarkus-antora"
  description            = "Build and serve Antora documentation site"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-antora/dev/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "antora", "documentation"]
}

# Create team
resource "github_team" "quarkus_antora" {
  name                      = "quarkiverse-antora"
  description               = "antora team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_antora" {
  team_id    = github_team.quarkus_antora.id
  repository = github_repository.quarkus_antora.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_antora" {
  for_each = { for tm in ["ppalaga"] : tm => tm }
  team_id  = github_team.quarkus_antora.id
  username = each.value
  role     = "maintainer"
}
