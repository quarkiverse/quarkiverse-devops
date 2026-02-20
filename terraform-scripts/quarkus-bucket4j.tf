# Create repository
resource "github_repository" "quarkus_bucket4j" {
  name                   = "quarkus-bucket4j"
  description            = "Java rate limiting library based on token-bucket algorithm Quarkus extension"
  homepage_url           = "https://bucket4j.com/"
  allow_merge_commit     = false
  allow_rebase_merge     = false
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_discussions        = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_bucket4j" {
  name                      = "quarkiverse-bucket4j"
  description               = "bucket4j team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_bucket4j" {
  team_id    = github_team.quarkus_bucket4j.id
  repository = github_repository.quarkus_bucket4j.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_bucket4j" {
  for_each = { for tm in ["rmanibus"] : tm => tm }
  team_id  = github_team.quarkus_bucket4j.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_bucket4j" {
  name        = "main"
  repository  = github_repository.quarkus_bucket4j.name
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

