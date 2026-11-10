# Create repository
resource "github_repository" "quarkus_sonify" {
  name                   = "quarkus-sonify"
  description            = "Hear your Quarkus application in dev mode: a sound for every HTTP request, response and custom event"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-sonify/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "dev-mode", "audio", "sonification", "developer-experience"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_sonify" {
  repository = github_repository.quarkus_sonify.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_sonify" {
  name           = "quarkiverse-sonify"
  description    = "sonify team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_sonify" {
  team_id    = github_team.quarkus_sonify.id
  repository = github_repository.quarkus_sonify.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_sonify" {
  for_each = { for tm in ["Eng-Fouad"] : tm => tm }
  team_id  = github_team.quarkus_sonify.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_sonify" {
  name        = "main"
  repository  = github_repository.quarkus_sonify.name
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
