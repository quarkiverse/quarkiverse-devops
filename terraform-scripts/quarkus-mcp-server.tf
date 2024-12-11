# Create repository
resource "github_repository" "quarkus_mcp_server" {
  name                   = "quarkus-mcp-server"
  description            = "This extension enables developers to implement the MCP server features easily."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-mcp-server/dev/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_mcp_server" {
  name                      = "quarkiverse-mcp-server"
  description               = "mcp-server team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mcp_server" {
  team_id    = github_team.quarkus_mcp_server.id
  repository = github_repository.quarkus_mcp_server.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mcp_server" {
  for_each = { for tm in ["mkouba"] : tm => tm }
  team_id  = github_team.quarkus_mcp_server.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_mcp_server" {
  name        = "main"
  repository  = github_repository.quarkus_mcp_server.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = data.github_app.quarkiverse_ci.id
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  rules {
    # Prevent force push
    non_fast_forward = true
    # Require pull request reviews before merging
    pull_request {

    }
  }
}
