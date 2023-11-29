# Create repository
resource "github_repository" "quarkus_code_server" {
  name                   = "quarkus-code-server"
  description            = "Allow to have access to code-server from Dev UI"
  homepage_url           = "https://github.com/coder/code-server"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_code_server" {
  name                      = "quarkiverse-code-server"
  description               = "code-server team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_code_server" {
  team_id    = github_team.quarkus_code_server.id
  repository = github_repository.quarkus_code_server.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_code_server" {
  for_each = { for tm in ["maxandersen"] : tm => tm }
  team_id  = github_team.quarkus_code_server.id
  username = each.value
  role     = "maintainer"
}
