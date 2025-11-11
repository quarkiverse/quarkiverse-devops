# Create repository
resource "github_repository" "quarkus_flags" {
  name                   = "quarkus-flags"
  description            = "A lightweight and extensible feature flag extension"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-flags/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "feature-flags", "toggles"]
}

# Create team
resource "github_team" "quarkus_flags" {
  name                      = "quarkiverse-flags"
  description               = "flags team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_flags" {
  team_id    = github_team.quarkus_flags.id
  repository = github_repository.quarkus_flags.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_flags" {
  for_each = { for tm in ["mkouba"] : tm => tm }
  team_id  = github_team.quarkus_flags.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_flags" {
  name        = "main"
  repository  = github_repository.quarkus_flags.name
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