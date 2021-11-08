# Create repository
resource "github_repository" "quarkus_shardingsphere_jdbc" {
  name                   = "quarkus-shardingsphere-jdbc"
  description            = "Quarkus Sharding Sphere JDBC Extension"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["middleware", "database", "distributed", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_shardingsphere_jdbc" {
  name                      = "quarkiverse-shardingsphere-jdbc"
  description               = "Quarkiverse team for the Sharding Sphere JDBC extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_shardingsphere_jdbc" {
  team_id    = github_team.quarkus_shardingsphere_jdbc.id
  repository = github_repository.quarkus_shardingsphere_jdbc.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_shardingsphere_jdbc" {
  for_each = { for tm in ["zhfeng"] : tm => tm }
  team_id  = github_team.quarkus_shardingsphere_jdbc.id
  username = each.value
  role     = "maintainer"
}
