# Create repository
resource "github_repository" "quarkus_queryable" {
  name                   = "quarkus-queryable"
  description            = "Annotation-driven advanced filtering for Hibernate ORM REST Data Panache"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-queryable/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics = ["quarkus-extension", "hibernate-orm", "hibernate-panache", "rest-data-panache", "jakarta-rest", "rest-api",
  "filtering", "criteria-api", "openapi", "java", "enterprise"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_queryable" {
  repository = github_repository.quarkus_queryable.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_queryable" {
  name           = "quarkiverse-queryable"
  description    = "queryable team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_queryable" {
  team_id    = github_team.quarkus_queryable.id
  repository = github_repository.quarkus_queryable.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_queryable" {
  for_each = { for tm in ["fiorenzino"] : tm => tm }
  team_id  = github_team.quarkus_queryable.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_queryable" {
  name        = "main"
  repository  = github_repository.quarkus_queryable.name
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
