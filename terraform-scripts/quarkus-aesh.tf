# Create repository
resource "github_repository" "quarkus_aesh" {
  name                   = "quarkus-aesh"
  description            = "Aesh, fully fledged repl cli combined with the powers of Quarkus"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-aesh/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_aesh" {
  name                      = "quarkiverse-aesh"
  description               = "aesh team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_aesh" {
  team_id    = github_team.quarkus_aesh.id
  repository = github_repository.quarkus_aesh.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_aesh" {
  for_each = { for tm in ["stalep"] : tm => tm }
  team_id  = github_team.quarkus_aesh.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_aesh" {
  name        = "main"
  repository  = github_repository.quarkus_aesh.name
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