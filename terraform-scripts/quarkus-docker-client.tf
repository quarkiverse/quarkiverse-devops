# Create repository
resource "github_repository" "quarkus_docker_client" {
  name                   = "quarkus-docker-client"
  description            = "Docker Java client integration for Quarkus"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-docker-client/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "docker", "docker-api", "container", "containerization"]
}

# Create team
resource "github_team" "quarkus_docker_client" {
  name                      = "quarkiverse-docker-client"
  description               = "docker-client team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_docker_client" {
  team_id    = github_team.quarkus_docker_client.id
  repository = github_repository.quarkus_docker_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_docker_client" {
  for_each = { for tm in ["zZHorizonZz"] : tm => tm }
  team_id  = github_team.quarkus_docker_client.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_docker_client" {
  name        = "main"
  repository  = github_repository.quarkus_docker_client.name
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
