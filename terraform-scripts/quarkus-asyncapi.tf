# Create repository
resource "github_repository" "quarkus_asyncapi" {
  name                   = "quarkus-asyncapi"
  description            = "AsyncAPI Quarkus configuration and metadata generator"
  homepage_url           = "https://www.asyncapi.com/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "asyncapi"]
}

# Create team
resource "github_team" "quarkus_asyncapi" {
  name                      = "quarkiverse-asyncapi"
  description               = "AsyncAPI team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_asyncapi" {
  team_id    = github_team.quarkus_asyncapi.id
  repository = github_repository.quarkus_asyncapi.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_asyncapi" {
  for_each = { for tm in ["fjtirado", "ricardozanini", "ChMThiel"] : tm => tm }
  team_id  = github_team.quarkus_asyncapi.id
  username = each.value
  role     = "maintainer"
}
