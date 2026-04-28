# Create repository
resource "github_repository" "quarkus_qdrant" {
  name                   = "quarkus-qdrant"
  description            = "Rest client for Qdrant vector database"
  visibility             = "public"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-qdrant/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "qdrant", "vector-database", "rest-client", "embedding"]
}

resource "github_repository_vulnerability_alerts" "quarkus_qdrant" {
  repository = github_repository.quarkus_qdrant.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_qdrant" {
  name           = "quarkiverse-qdrant"
  description    = "qdrant team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_qdrant" {
  team_id    = github_team.quarkus_qdrant.id
  repository = github_repository.quarkus_qdrant.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_qdrant" {
  for_each = { for tm in ["zbendhiba", "gansheer"] : tm => tm }
  team_id  = github_team.quarkus_qdrant.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_qdrant" {
  name        = "main"
  repository  = github_repository.quarkus_qdrant.name
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
