# Create repository
resource "github_repository" "quarkus_wiremock" {
  name                   = "quarkus-wiremock"
  description            = "Quarkus extension for launching an in-process Wiremock server"
  homepage_url           = "https://wiremock.org/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "wiremock"]
}

# Create team
resource "github_team" "quarkus_wiremock" {
  name                      = "quarkiverse-wiremock"
  description               = "wiremock team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_wiremock" {
  team_id    = github_team.quarkus_wiremock.id
  repository = github_repository.quarkus_wiremock.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_wiremock" {
  for_each = { for tm in ["Spanjer1", "chberger", "wjglerum"] : tm => tm }
  team_id  = github_team.quarkus_wiremock.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_wiremock" {
  name        = "main"
  repository  = github_repository.quarkus_wiremock.name
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
