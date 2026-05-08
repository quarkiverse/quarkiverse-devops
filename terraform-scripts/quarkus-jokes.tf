# Create repository
resource "github_repository" "quarkus_jokes" {
  name                   = "quarkus-jokes"
  description            = "Example extension to showcase Dev UI and Dev MCP features"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-jokes/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "example"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_jokes" {
  repository = github_repository.quarkus_jokes.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_jokes" {
  name           = "quarkiverse-jokes"
  description    = "jokes team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jokes" {
  team_id    = github_team.quarkus_jokes.id
  repository = github_repository.quarkus_jokes.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jokes" {
  for_each = { for tm in ["holly-cummins", "phillip-kruger"] : tm => tm }
  team_id  = github_team.quarkus_jokes.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_jokes" {
  name        = "main"
  repository  = github_repository.quarkus_jokes.name
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
