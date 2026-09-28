# Create repository
resource "github_repository" "quarkus_desktop" {
  name                   = "quarkus-desktop"
  description            = "Build AWT and Swing desktop applications with Quarkus, native on Windows, Linux and macOS"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-desktop/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "desktop", "awt", "swing", "java2d", "gui", "graalvm", "native-image"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_desktop" {
  repository = github_repository.quarkus_desktop.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_desktop" {
  name           = "quarkiverse-desktop"
  description    = "desktop team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_desktop" {
  team_id    = github_team.quarkus_desktop.id
  repository = github_repository.quarkus_desktop.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_desktop" {
  for_each = { for tm in ["Eng-Fouad"] : tm => tm }
  team_id  = github_team.quarkus_desktop.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_desktop" {
  name        = "main"
  repository  = github_repository.quarkus_desktop.name
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
