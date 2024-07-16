# Create repository
resource "github_repository" "quarkus_json_rpc" {
  name                   = "quarkus-json-prc"
  description            = "JsonRPC over WebSocket services with Quarkus"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-json-rpc/dev/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "json-rpc", "websocket"]
}

# Create team
resource "github_team" "quarkus_json_rpc" {
  name                      = "quarkiverse-json-rpc"
  description               = "json-rpc team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_json_rpc" {
  team_id    = github_team.quarkus_json_rpc.id
  repository = github_repository.quarkus_json_rpc.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_json_rpc" {
  for_each = { for tm in ["phillip-kruger", "tecarter94"] : tm => tm }
  team_id  = github_team.quarkus_json_rpc.id
  username = each.value
  role     = "maintainer"
}
