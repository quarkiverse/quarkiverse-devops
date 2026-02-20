# Create repository
resource "github_repository" "quarkus_observability_minecraft" {
  name                   = "quarkus-observability-minecraft"
  description            = "This extension allows Minecraft to be used as an observability client to monitor events in a Quarkus application"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-observability-minecraft/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "demo", "minecraft", "observability"]
}

# Create team
resource "github_team" "quarkus_observability_minecraft" {
  name                      = "quarkiverse-observability-minecraft"
  description               = "observability-minecraft team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_observability_minecraft" {
  team_id    = github_team.quarkus_observability_minecraft.id
  repository = github_repository.quarkus_observability_minecraft.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_observability_minecraft" {
  for_each = { for tm in ["holly-cummins"] : tm => tm }
  team_id  = github_team.quarkus_observability_minecraft.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_observability_minecraft" {
  name        = "main"
  repository  = github_repository.quarkus_observability_minecraft.name
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
