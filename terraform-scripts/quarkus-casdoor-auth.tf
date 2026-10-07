# Create repository
resource "github_repository" "quarkus_casdoor_auth" {
  name                   = "quarkus-casdoor-auth"
  description            = "Quarkus extension for Casdoor authentication"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-casdoor-auth/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "security"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_casdoor_auth" {
  repository = github_repository.quarkus_casdoor_auth.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_casdoor_auth" {
  name           = "quarkiverse-casdoor-auth"
  description    = "casdoor-auth team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_casdoor_auth" {
  team_id    = github_team.quarkus_casdoor_auth.id
  repository = github_repository.quarkus_casdoor_auth.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_casdoor_auth" {
  for_each = { for tm in ["raiki02", "hsluoyz"] : tm => tm }
  team_id  = github_team.quarkus_casdoor_auth.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_casdoor_auth" {
  name        = "main"
  repository  = github_repository.quarkus_casdoor_auth.name
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
