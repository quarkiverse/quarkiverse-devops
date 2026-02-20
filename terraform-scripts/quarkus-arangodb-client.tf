# Create repository
resource "github_repository" "quarkus_arangodb_client" {
  name                   = "quarkus-arangodb-client"
  description            = "Connect to ArangoDB with Quarkus"
  homepage_url           = "https://www.arangodb.com/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "arangodb", "client"]
}

# Create team
resource "github_team" "quarkus_arangodb_client" {
  name                      = "quarkiverse-arangodb-client"
  description               = "arangodb-client team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_arangodb_client" {
  team_id    = github_team.quarkus_arangodb_client.id
  repository = github_repository.quarkus_arangodb_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_arangodb_client" {
  for_each = { for tm in ["dcdh"] : tm => tm }
  team_id  = github_team.quarkus_arangodb_client.id
  username = each.value
  role     = "maintainer"
}
