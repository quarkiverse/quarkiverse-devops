# Create repository
resource "github_repository" "quarkus_spdx" {
  name                   = "quarkus-spdx"
  description            = "Quarkus SPDX SBOM generator"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-spdx/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

resource "github_repository_vulnerability_alerts" "quarkus_spdx" {
  repository = github_repository.quarkus_spdx.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_spdx" {
  name           = "quarkiverse-spdx"
  description    = "spdx team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_spdx" {
  team_id    = github_team.quarkus_spdx.id
  repository = github_repository.quarkus_spdx.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_spdx" {
  for_each = { for tm in ["aloubyansky"] : tm => tm }
  team_id  = github_team.quarkus_spdx.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_spdx" {
  name        = "main"
  repository  = github_repository.quarkus_spdx.name
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