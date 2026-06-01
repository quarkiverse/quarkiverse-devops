# Create repository
resource "github_repository" "quarkus_multitenancy" {
  name                   = "quarkus-multitenancy"
  description            = "A fully decoupled Quarkus extension providing a generic tenant resolution API and request-scoped TenantContext, with pluggable resolvers for HTTP, JWT, cookies"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-multitenancy/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "multitenancy", "tenant-resolution", "java", "quarkiverse", "microservices"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_multitenancy" {
  repository = github_repository.quarkus_multitenancy.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_multitenancy" {
  name           = "quarkiverse-multitenancy"
  description    = "multitenancy team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_multitenancy" {
  team_id    = github_team.quarkus_multitenancy.id
  repository = github_repository.quarkus_multitenancy.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_multitenancy" {
  for_each = { for tm in ["lu1tr0n", "mathias82"] : tm => tm }
  team_id  = github_team.quarkus_multitenancy.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_multitenancy" {
  name        = "main"
  repository  = github_repository.quarkus_multitenancy.name
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