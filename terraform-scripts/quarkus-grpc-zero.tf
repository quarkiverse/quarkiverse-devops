# Create repository
resource "github_repository" "quarkus_grpc_zero" {
  name                   = "quarkus-grpc-zero"
  description            = "gRPC Zero Codegen is a JVM-only, self-contained protoc codegen implementation for Quarkus projects"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-grpc-zero/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "grpc", "codegen", "protoc"]
}

# Create team
resource "github_team" "quarkus_grpc_zero" {
  name                      = "quarkiverse-grpc-zero"
  description               = "grpc-zero team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_grpc_zero" {
  team_id    = github_team.quarkus_grpc_zero.id
  repository = github_repository.quarkus_grpc_zero.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_grpc_zero" {
  for_each = { for tm in ["andreaTP", "alesj"] : tm => tm }
  team_id  = github_team.quarkus_grpc_zero.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_grpc_zero" {
  name        = "main"
  repository  = github_repository.quarkus_grpc_zero.name
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
