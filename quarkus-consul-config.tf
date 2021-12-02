# Create repository
resource "github_repository" "quarkus_consul_config" {
  name                   = "quarkus-consul-config"
  description            = "Quarkus Consul Config extension"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_consul_config" {
  name                      = "quarkiverse-consul-config"
  description               = "Quarkiverse team for the Consul Config extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_consul_config" {
  team_id    = github_team.quarkus_consul_config.id
  repository = github_repository.quarkus_consul_config.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_consul_config" {
  for_each = { for tm in ["geoand"] : tm => tm }
  team_id  = github_team.quarkus_consul_config.id
  username = each.value
  role     = "maintainer"
}
