# Create repository
resource "github_repository" "quarkus_fleet_test" {
  name                   = "quarkus-fleet-test"
  description            = "Run several instances of your Quarkus application behind a load balancer, inside one JUnit test"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-fleet-test/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "testing", "resilience"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_fleet_test" {
  repository = github_repository.quarkus_fleet_test.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_fleet_test" {
  name           = "quarkiverse-fleet-test"
  description    = "fleet-test team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_fleet_test" {
  team_id    = github_team.quarkus_fleet_test.id
  repository = github_repository.quarkus_fleet_test.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_fleet_test" {
  for_each = { for tm in ["geoand"] : tm => tm }
  team_id  = github_team.quarkus_fleet_test.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_fleet_test" {
  name        = "main"
  repository  = github_repository.quarkus_fleet_test.name
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
