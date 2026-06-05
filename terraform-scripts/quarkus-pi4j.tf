# Create repository
resource "github_repository" "quarkus_pi4j" {
  name                   = "quarkus-pi4j"
  description            = "Quarkus extension for Pi4J, enabling Raspberry Pi GPIO and hardware I/O integration in Quarkus applications"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-pi4j/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "pi4j", "raspberry-pi", "gpio", "iot", "edge", "hardware", "embedded", "java", "quarkus"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_pi4j" {
  repository = github_repository.quarkus_pi4j.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_pi4j" {
  name           = "quarkiverse-pi4j"
  description    = "pi4j team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_pi4j" {
  team_id    = github_team.quarkus_pi4j.id
  repository = github_repository.quarkus_pi4j.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_pi4j" {
  for_each = { for tm in ["igfasouza"] : tm => tm }
  team_id  = github_team.quarkus_pi4j.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_pi4j" {
  name        = "main"
  repository  = github_repository.quarkus_pi4j.name
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
