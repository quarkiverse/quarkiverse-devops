# Create repository
resource "github_repository" "quarkus_jms" {
  name                   = "quarkus-jms"
  description            = "JMS extension for Quarkus providing type-safe destinations and annotation-driven listeners"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-jms/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_jms" {
  repository = github_repository.quarkus_jms.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_jms" {
  name           = "quarkiverse-jms"
  description    = "jms team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jms" {
  team_id    = github_team.quarkus_jms.id
  repository = github_repository.quarkus_jms.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_jms" {
  for_each = { for tm in ["ozangunalp"] : tm => tm }
  team_id  = github_team.quarkus_jms.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_jms" {
  name        = "main"
  repository  = github_repository.quarkus_jms.name
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
