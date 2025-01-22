# Create repository
resource "github_repository" "quarkus_mcp_servers" {
  name                   = "quarkus-mcp-servers"
  description            = "Model Context Protocol Servers in Quarkus"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["mcp"]
}

# Create team
resource "github_team" "quarkus_mcp_servers" {
  name                      = "quarkiverse-mcp-servers"
  description               = "mcp-servers team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mcp_servers" {
  team_id    = github_team.quarkus_mcp_servers.id
  repository = github_repository.quarkus_mcp_servers.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mcp_servers" {
  for_each = { for tm in ["maxandersen"] : tm => tm }
  team_id  = github_team.quarkus_mcp_servers.id
  username = each.value
  role     = "maintainer"
}
