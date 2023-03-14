# Create repository
resource "github_repository" "quarkus_reactive_mysql_pool_client" {
  name                   = "quarkus-reactive-mysql-pool-client"
  description            = "Reactive MySQL Pool client for Quarkus"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "mysql", "reactive"]
}

# Create team
resource "github_team" "quarkus_reactive_mysql_pool_client" {
  name                      = "quarkiverse-reactive-mysql-pool-client"
  description               = "reactive-mysql-pool-client team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_reactive_mysql_pool_client" {
  team_id    = github_team.quarkus_reactive_mysql_pool_client.id
  repository = github_repository.quarkus_reactive_mysql_pool_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_reactive_mysql_pool_client" {
  for_each = { for tm in ["benstonezhang"] : tm => tm }
  team_id  = github_team.quarkus_reactive_mysql_pool_client.id
  username = each.value
  role     = "maintainer"
}