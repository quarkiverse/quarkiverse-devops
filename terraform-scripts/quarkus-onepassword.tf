# Create repository
resource "github_repository" "quarkus_onepassword" {
  name                   = "quarkus-onepassword"
  description            = "Access secrets from 1Password vault"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-onepassword/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_onepassword" {
  repository = github_repository.quarkus_onepassword.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_onepassword" {
  name           = "quarkiverse-onepassword"
  description    = "onepassword team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_onepassword" {
  team_id    = github_team.quarkus_onepassword.id
  repository = github_repository.quarkus_onepassword.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_onepassword" {
  for_each = { for tm in ["maxandersen"] : tm => tm }
  team_id  = github_team.quarkus_onepassword.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_onepassword" {
  name        = "main"
  repository  = github_repository.quarkus_onepassword.name
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
