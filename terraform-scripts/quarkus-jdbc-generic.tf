# Create repository
resource "github_repository" "quarkus_jdbc_generic" {
  name                   = "quarkus-jdbc-generic"
  description            = "Connect a Quarkus Agroal datasource to any database via a JDBC driver resolved at runtime"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-jdbc-generic/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_jdbc_generic" {
  repository = github_repository.quarkus_jdbc_generic.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_jdbc_generic" {
  name           = "quarkiverse-jdbc-generic"
  description    = "jdbc-generic team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jdbc_generic" {
  team_id    = github_team.quarkus_jdbc_generic.id
  repository = github_repository.quarkus_jdbc_generic.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_jdbc_generic" {
  for_each = { for tm in ["rmannibucau"] : tm => tm }
  team_id  = github_team.quarkus_jdbc_generic.id
  username = each.value
  role     = "maintainer"
}
