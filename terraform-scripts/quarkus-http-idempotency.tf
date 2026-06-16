# Create repository
resource "github_repository" "quarkus_http_idempotency" {
  name                   = "quarkus-http-idempotency"
  description            = "Make POST and PATCH idempotent"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-http-idempotency/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_http_idempotency" {
  repository = github_repository.quarkus_http_idempotency.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_http_idempotency" {
  name           = "quarkiverse-http-idempotency"
  description    = "http-idempotency team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_http_idempotency" {
  team_id    = github_team.quarkus_http_idempotency.id
  repository = github_repository.quarkus_http_idempotency.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_http_idempotency" {
  for_each = { for tm in ["akil-rails", "lu1tr0n"] : tm => tm }
  team_id  = github_team.quarkus_http_idempotency.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_http_idempotency" {
  name        = "main"
  repository  = github_repository.quarkus_http_idempotency.name
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
