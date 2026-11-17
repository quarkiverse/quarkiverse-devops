# Create repository
resource "github_repository" "quarkus_modulith" {
  name                   = "quarkus-modulith"
  description            = "Verify application module boundaries at build time and connect modules with transactional events"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-modulith/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "modulith", "modular-modulith", "domain-driven-design", "architecture", "outbox"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_modulith" {
  repository = github_repository.quarkus_modulith.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_modulith" {
  name           = "quarkiverse-modulith"
  description    = "modulith team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_modulith" {
  team_id    = github_team.quarkus_modulith.id
  repository = github_repository.quarkus_modulith.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_modulith" {
  for_each = { for tm in ["Lucas-Angelo"] : tm => tm }
  team_id  = github_team.quarkus_modulith.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_modulith" {
  name        = "main"
  repository  = github_repository.quarkus_modulith.name
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

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_modulith" {
  for_each = { for app in [local.applications.renovate] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_modulith.name
}
