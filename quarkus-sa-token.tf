# Create repository
resource "github_repository" "quarkus_sa_token" {
  name                   = "quarkus-sa-token"
  description            = "A lightweight Java permission authentication framework, which mainly solves a series of permission related problems such as login authentication, permission authentication, SSO, OAuth2.0, and micro-service authentication"
  homepage_url           = "https://sa-token.dev33.cn/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_sa_token" {
  name                      = "quarkiverse-sa-token"
  description               = "sa-token team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_sa_token" {
  team_id    = github_team.quarkus_sa_token.id
  repository = github_repository.quarkus_sa_token.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_sa_token" {
  for_each = { for tm in ["naah69", "click33"] : tm => tm }
  team_id  = github_team.quarkus_sa_token.id
  username = each.value
  role     = "maintainer"
}
