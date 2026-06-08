# Create repository
resource "github_repository" "quarkus_messaging_pgmq" {
  name                   = "quarkus-messaging-pgmq"
  description            = "Extension and messaging connector to support PGMQ (Postgres Message Queue)"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-messaging-pgmq/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "quarkus-messaging", "pgmq"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_messaging_pgmq" {
  repository = github_repository.quarkus_messaging_pgmq.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_messaging_pgmq" {
  name           = "quarkiverse-messaging-pgmq"
  description    = "messaging-pgmq team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_messaging_pgmq" {
  team_id    = github_team.quarkus_messaging_pgmq.id
  repository = github_repository.quarkus_messaging_pgmq.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_messaging_pgmq" {
  for_each = { for tm in ["ozangunalp"] : tm => tm }
  team_id  = github_team.quarkus_messaging_pgmq.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_messaging_pgmq" {
  name        = "main"
  repository  = github_repository.quarkus_messaging_pgmq.name
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
