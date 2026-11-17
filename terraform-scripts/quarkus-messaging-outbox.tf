# Create repository
resource "github_repository" "quarkus_messaging_outbox" {
  name                   = "quarkus-messaging-outbox"
  description            = "Transactional outbox pattern for Quarkus Messaging"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-messaging-outbox/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "quarkus-messaging"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_messaging_outbox" {
  repository = github_repository.quarkus_messaging_outbox.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_messaging_outbox" {
  name           = "quarkiverse-messaging-outbox"
  description    = "messaging-outbox team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_messaging_outbox" {
  team_id    = github_team.quarkus_messaging_outbox.id
  repository = github_repository.quarkus_messaging_outbox.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_messaging_outbox" {
  for_each = { for tm in ["ozangunalp"] : tm => tm }
  team_id  = github_team.quarkus_messaging_outbox.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_messaging_outbox" {
  name        = "main"
  repository  = github_repository.quarkus_messaging_outbox.name
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
