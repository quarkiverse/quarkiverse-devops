# Create repository
resource "github_repository" "quarkus_jdbc_sqlite" {
  name                   = "quarkus-jdbc-sqlite"
  description            = "Basic SQLite driver for Quarkus with Agoral and native mode support"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_jdbc_sqlite" {
  name                      = "quarkiverse-jdbc-sqlite"
  description               = "jdbc-sqlite team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
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
