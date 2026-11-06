# Create repository
resource "github_repository" "quarkus_jdbc_db2" {
  name                   = "quarkus-jdbc-db2"
  description            = "Quarkus DB2 JDBC Driver Extension"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-jdbc-db2/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_jdbc_db2" {
  repository = github_repository.quarkus_jdbc_db2.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_jdbc_db2" {
  name           = "quarkiverse-jdbc-db2"
  description    = "jdbc-db2 team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jdbc_db2" {
  team_id    = github_team.quarkus_jdbc_db2.id
  repository = github_repository.quarkus_jdbc_db2.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_jdbc_db2" {
  for_each = { for tm in ["Sanne"] : tm => tm }
  team_id  = github_team.quarkus_jdbc_db2.id
  username = each.value
  role     = "maintainer"
}
