# Create repository
resource "github_repository" "quarkus_jdbc_sqlite" {
  name                   = "quarkus-jdbc-sqlite"
  description            = "Basic SQLite driver for Quarkus with Agroal and native mode support"
  archive_on_destroy     = true
  allow_update_branch    = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["jdbc", "sqlite", "quarkus-extension"]
}

resource "github_repository_vulnerability_alerts" "quarkus_jdbc_sqlite" {
  repository = github_repository.quarkus_jdbc_sqlite.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_jdbc_sqlite" {
  name           = "quarkiverse-jdbc-sqlite"
  description    = "jdbc-sqlite team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jdbc_sqlite" {
  team_id    = github_team.quarkus_jdbc_sqlite.id
  repository = github_repository.quarkus_jdbc_sqlite.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jdbc_sqlite" {
  for_each = { for tm in ["alexeysharandin"] : tm => tm }
  team_id  = github_team.quarkus_jdbc_sqlite.id
  username = each.value
  role     = "maintainer"
}
