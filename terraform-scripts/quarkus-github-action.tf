# Create repository
resource "github_repository" "quarkus_github_action" {
  name                   = "quarkus-github-action"
  description            = "Develop your GitHub Actions in Java with Quarkus."
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  vulnerability_alerts   = true
  homepage_url           = "https://docs.quarkiverse.io/quarkus-github-action/dev/index.html"
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_github_action" {
  name                      = "quarkiverse-github-action"
  description               = "Quarkiverse team for the GitHub Action extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_github_action" {
  team_id    = github_team.quarkus_github_action.id
  repository = github_repository.quarkus_github_action.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_github_action" {
  for_each = { for tm in ["gsmet"] : tm => tm }
  team_id  = github_team.quarkus_github_action.id
  username = each.value
  role     = "maintainer"
}
