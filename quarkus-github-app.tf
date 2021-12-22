# Create repository
resource "github_repository" "quarkus_github_app" {
  name                   = "quarkus-github-app"
  description            = "Develop your GitHub Apps in Java with Quarkus."
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  vulnerability_alerts   = true
  homepage_url           = "https://quarkiverse.github.io/quarkiverse-docs/quarkus-github-app/dev/index.html"
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_github_app" {
  name                      = "quarkiverse-github-app"
  description               = "Quarkiverse team for the GitHub App extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_github_app" {
  team_id    = github_team.quarkus_github_app.id
  repository = github_repository.quarkus_github_app.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_github_app" {
  for_each = { for tm in ["gsmet"] : tm => tm }
  team_id  = github_team.quarkus_github_app.id
  username = each.value
  role     = "maintainer"
}

# Add outside collaborators to the repository
resource "github_repository_collaborator" "quarkus_github_app" {
  for_each   = { for tm in ["yrodiere"] : tm => tm }
  repository = github_repository.quarkus_github_app.name
  username   = each.value
  permission = "push"
}
