# Create repository
resource "github_repository" "quarkus_db_scheduler" {
  name                   = "quarkus-db-scheduler"
  description            = "A Quarkus extension to schedule tasks using a database as a backend."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-db-scheduler/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "quarkus", "scheduler", "database", "quarkiverse"]
}

# Create team
resource "github_team" "quarkus_db_scheduler" {
  name           = "quarkiverse-db-scheduler"
  description    = "db-scheduler team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_db_scheduler" {
  team_id    = github_team.quarkus_db_scheduler.id
  repository = github_repository.quarkus_db_scheduler.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_db_scheduler" {
  for_each = { for tm in ["mkouba"] : tm => tm }
  team_id  = github_team.quarkus_db_scheduler.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_db_scheduler" {
  name        = "main"
  repository  = github_repository.quarkus_db_scheduler.name
  target      = "branch"
  enforcement = "disabled"

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
