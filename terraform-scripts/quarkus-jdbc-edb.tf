# Create repository
resource "github_repository" "quarkus_jdbc_edb" {
  name                   = "quarkus-jdbc-edb"
  description            = "EDB JDBC Driver Extension for Quarkus"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-jdbc-edb/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_jdbc_edb" {
  repository = github_repository.quarkus_jdbc_edb.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_jdbc_edb" {
  name           = "quarkiverse-jdbc-edb"
  description    = "jdbc-edb team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jdbc_edb" {
  team_id    = github_team.quarkus_jdbc_edb.id
  repository = github_repository.quarkus_jdbc_edb.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_jdbc_edb" {
  for_each = { for tm in ["ericmack", "moazzumali"] : tm => tm }
  team_id  = github_team.quarkus_jdbc_edb.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_jdbc_edb" {
  name        = "main"
  repository  = github_repository.quarkus_jdbc_edb.name
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
