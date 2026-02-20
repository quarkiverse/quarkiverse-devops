# Create repository
resource "github_repository" "quarkus_authzed_client" {
  name                   = "quarkus-authzed-client"
  description            = "An extension for connecting to authzed instances from Quarkus applications"
  homepage_url           = "https://docs.authzed.com/reference/api"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "authzed", "fga"]
}

# Create team
resource "github_team" "quarkus_authzed_client" {
  name                      = "quarkiverse-authzed-client"
  description               = "authzed-client team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_authzed_client" {
  team_id    = github_team.quarkus_authzed_client.id
  repository = github_repository.quarkus_authzed_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_authzed_client" {
  for_each = { for tm in ["iocanel", "kdubb"] : tm => tm }
  team_id  = github_team.quarkus_authzed_client.id
  username = each.value
  role     = "maintainer"
}
