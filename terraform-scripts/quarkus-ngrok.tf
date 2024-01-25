# Create repository
resource "github_repository" "quarkus_ngrok" {
  name                   = "quarkus-ngrok"
  description            = "ngrok is a globally distributed reverse proxy fronting your web services running in any cloud or private network, or your machine"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-ngrok/dev/index.html"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_ngrok" {
  name                      = "quarkiverse-ngrok"
  description               = "ngrok team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_ngrok" {
  team_id    = github_team.quarkus_ngrok.id
  repository = github_repository.quarkus_ngrok.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_ngrok" {
  for_each = { for tm in ["geoand", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_ngrok.id
  username = each.value
  role     = "maintainer"
}
