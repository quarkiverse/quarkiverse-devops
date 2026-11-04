# Create repository
resource "github_repository" "quarkus_topaz" {
  name                   = "quarkus-topaz"
  description            = "Client, Dev Services and security enforcement for the Topaz authorizer and directory"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-topaz/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "topaz", "authorization", "rebac", "opa", "zanzibar"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_topaz" {
  repository = github_repository.quarkus_topaz.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_topaz" {
  name           = "quarkiverse-topaz"
  description    = "topaz team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_topaz" {
  team_id    = github_team.quarkus_topaz.id
  repository = github_repository.quarkus_topaz.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_topaz" {
  for_each = { for tm in ["jnbdz"] : tm => tm }
  team_id  = github_team.quarkus_topaz.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_topaz" {
  name        = "main"
  repository  = github_repository.quarkus_topaz.name
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
