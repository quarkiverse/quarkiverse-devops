# Create repository
resource "github_repository" "quarkus_network_faults" {
  name                   = "quarkus-network-faults"
  description            = "Quarkus extension that lets developers verify what a request does when a dependency is down, unreachable, slow, hung, or dies mid-call"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-network-faults/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "testing"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_network_faults" {
  repository = github_repository.quarkus_network_faults.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_network_faults" {
  name           = "quarkiverse-network-faults"
  description    = "network-faults team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_network_faults" {
  team_id    = github_team.quarkus_network_faults.id
  repository = github_repository.quarkus_network_faults.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_network_faults" {
  for_each = { for tm in ["geoand"] : tm => tm }
  team_id  = github_team.quarkus_network_faults.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_network_faults" {
  name        = "main"
  repository  = github_repository.quarkus_network_faults.name
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
