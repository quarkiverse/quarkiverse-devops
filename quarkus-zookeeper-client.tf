# Create repository
resource "github_repository" "quarkus_zookeeper_client" {
  name                   = "quarkus-zookeeper-client"
  description            = "An Apache Zookeeper client Quarkus Extension"
  homepage_url           = "https://zookeeper.apache.org/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "client", "zookeeper"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_zookeeper_client" {
  name                      = "quarkiverse-zookeeper-client"
  description               = "zookeeper-client team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_zookeeper_client" {
  team_id    = github_team.quarkus_zookeeper_client.id
  repository = github_repository.quarkus_zookeeper_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_zookeeper_client" {
  for_each = { for tm in ["morphy76"] : tm => tm }
  team_id  = github_team.quarkus_zookeeper_client.id
  username = each.value
  role     = "maintainer"
}
