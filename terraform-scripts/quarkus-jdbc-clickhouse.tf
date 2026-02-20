# Create repository
resource "github_repository" "quarkus_jdbc_clickhouse" {
  name                   = "quarkus-jdbc-clickhouse"
  description            = "ClickHouse driver for Quarkus with Agroal and native mode support"
  homepage_url           = "https://clickhouse.com/clickhouse"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["jdbc", "clickhouse", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_jdbc_clickhouse" {
  name                      = "quarkiverse-jdbc-clickhouse"
  description               = "jdbc-clickhouse team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jdbc_clickhouse" {
  team_id    = github_team.quarkus_jdbc_clickhouse.id
  repository = github_repository.quarkus_jdbc_clickhouse.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jdbc_clickhouse" {
  for_each = { for tm in ["alexeysharandin"] : tm => tm }
  team_id  = github_team.quarkus_jdbc_clickhouse.id
  username = each.value
  role     = "maintainer"
}
