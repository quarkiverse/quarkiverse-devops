# Create repository
resource "github_repository" "quarkus_redoc" {
  name                   = "quarkus-redoc"
  description            = "OpenAPI/Swagger-generated API Reference Documentation"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-redoc/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_redoc" {
  name                      = "quarkiverse-redoc"
  description               = "redoc team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_redoc" {
  team_id    = github_team.quarkus_redoc.id
  repository = github_repository.quarkus_redoc.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_redoc" {
  for_each = { for tm in ["Postremus"] : tm => tm }
  team_id  = github_team.quarkus_redoc.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_redoc" {
  name        = "main"
  repository  = github_repository.quarkus_redoc.name
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