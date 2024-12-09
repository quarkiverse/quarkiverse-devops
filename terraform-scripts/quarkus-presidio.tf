# Create repository
resource "github_repository" "quarkus_presidio" {
  name                   = "quarkus-presidio"
  description            = "Data Protection and De-identification SDK"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-presidio/dev/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "presidio", "obfuscation"]
}

# Create team
resource "github_team" "quarkus_presidio" {
  name                      = "quarkiverse-presidio"
  description               = "presidio team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_presidio" {
  team_id    = github_team.quarkus_presidio.id
  repository = github_repository.quarkus_presidio.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_presidio" {
  for_each = { for tm in ["lordofthejars"] : tm => tm }
  team_id  = github_team.quarkus_presidio.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_presidio" {
  name        = "main"
  repository  = github_repository.quarkus_presidio.name
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
