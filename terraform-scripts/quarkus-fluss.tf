# Create repository
resource "github_repository" "quarkus_fluss" {
  name                   = "quarkus-fluss"
  description            = "SmallRye Reactive Messaging connector for Apache Fluss"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-fluss/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "fluss", "smallrye", "reactive-messaging"]
}

resource "github_repository_vulnerability_alerts" "quarkus_fluss" {
  repository = github_repository.quarkus_fluss.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_fluss" {
  name           = "quarkiverse-fluss"
  description    = "fluss team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_fluss" {
  team_id    = github_team.quarkus_fluss.id
  repository = github_repository.quarkus_fluss.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_fluss" {
  for_each = { for tm in ["binary-signal"] : tm => tm }
  team_id  = github_team.quarkus_fluss.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_fluss" {
  name        = "main"
  repository  = github_repository.quarkus_fluss.name
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
