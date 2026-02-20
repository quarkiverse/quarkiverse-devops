# Create repository
resource "github_repository" "quarkus_fluentjdbc" {
  name                   = "quarkus-fluentjdbc"
  description            = "Integrates FluentJdbc with Quarkus and with GraalVM support"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-fluentjdbc/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "jdbc", "sql", "fluentjdbc", "database"]
}

# Create team
resource "github_team" "quarkus_fluentjdbc" {
  name                      = "quarkiverse-fluentjdbc"
  description               = "fluentjdbc team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_fluentjdbc" {
  team_id    = github_team.quarkus_fluentjdbc.id
  repository = github_repository.quarkus_fluentjdbc.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_fluentjdbc" {
  for_each = { for tm in ["Serkan80"] : tm => tm }
  team_id  = github_team.quarkus_fluentjdbc.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_fluentjdbc" {
  name        = "main"
  repository  = github_repository.quarkus_fluentjdbc.name
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
