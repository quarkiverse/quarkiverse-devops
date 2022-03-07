# Create repository
resource "github_repository" "quarkus_github_api" {
  name                   = "quarkus-github-api"
  description            = "Quarkus extension for the Hub4j GitHub API"
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_github_api" {
  name                      = "quarkiverse-github-api"
  description               = "Quarkiverse team for the GitHub API extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_github_api" {
  team_id    = github_team.quarkus_github_api.id
  repository = github_repository.quarkus_github_api.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_github_api" {
  for_each = { for tm in ["gsmet", "gastaldi"] : tm => tm }
  team_id  = github_team.quarkus_github_api.id
  username = each.value
  role     = "maintainer"
}
