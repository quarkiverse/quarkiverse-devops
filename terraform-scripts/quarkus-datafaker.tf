# Create repository
resource "github_repository" "quarkus_datafaker" {
  name                   = "quarkus-datafaker"
  description            = "Support Datafaker for native compilation"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-datafaker/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "datafaker"]
}

# Create team
resource "github_team" "quarkus_datafaker" {
  name                      = "quarkiverse-datafaker"
  description               = "datafaker team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_datafaker" {
  team_id    = github_team.quarkus_datafaker.id
  repository = github_repository.quarkus_datafaker.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_datafaker" {
  for_each = { for tm in ["jponge", "radcortez"] : tm => tm }
  team_id  = github_team.quarkus_datafaker.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_datafaker" {
  name        = "main"
  repository  = github_repository.quarkus_datafaker.name
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
