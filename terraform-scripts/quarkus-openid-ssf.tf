# Create repository
resource "github_repository" "quarkus_openid_ssf" {
  name                   = "quarkus-openid-ssf"
  description            = "Quarkus Extensions supporting the Shared Signals Framework (SSF)"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-openid-ssf/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "ssf", "shared-signals", "set", "secevent", "caep", "risc", "rfc8417", "rfc8935", "rfc8936", "keycloak", "oidc", "security"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_openid_ssf" {
  repository = github_repository.quarkus_openid_ssf.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_openid_ssf" {
  name           = "quarkiverse-openid-ssf"
  description    = "ssf team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_openid_ssf" {
  team_id    = github_team.quarkus_openid_ssf.id
  repository = github_repository.quarkus_openid_ssf.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_openid_ssf" {
  for_each = { for tm in ["thomasdarimont"] : tm => tm }
  team_id  = github_team.quarkus_openid_ssf.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_openid_ssf" {
  name        = "main"
  repository  = github_repository.quarkus_openid_ssf.name
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
