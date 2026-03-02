# Create repository
resource "github_repository" "quarkus_qubit" {
  name                   = "quarkus-qubit"
  description            = "A Quarkus extension that enables type-safe, lambda-based queries on Panache entities with build-time transformation to JPA Criteria Queries."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-qubit/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "database", "lambdas", "queries", "jpa", "panache"]
}

# Create team
resource "github_team" "quarkus_qubit" {
  name           = "quarkiverse-qubit"
  description    = "qubit team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_qubit" {
  team_id    = github_team.quarkus_qubit.id
  repository = github_repository.quarkus_qubit.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_qubit" {
  for_each = { for tm in ["ebramirez"] : tm => tm }
  team_id  = github_team.quarkus_qubit.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_qubit" {
  name        = "main"
  repository  = github_repository.quarkus_qubit.name
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