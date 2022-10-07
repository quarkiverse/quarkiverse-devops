# Create repository
resource "github_repository" "quarkus_mockserver" {
  name                   = "quarkus-mockserver"
  description            = "Quarkus MockServer Extension"
  homepage_url           = "https://mock-server.com/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "mockserver"]
}

# Create team
resource "github_team" "quarkus_mockserver" {
  name                      = "quarkiverse-mockserver"
  description               = "mockserver team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mockserver" {
  team_id    = github_team.quarkus_mockserver.id
  repository = github_repository.quarkus_mockserver.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mockserver" {
  for_each = { for tm in ["andrejpetras"] : tm => tm }
  team_id  = github_team.quarkus_mockserver.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_mockserver" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_mockserver.name
}

