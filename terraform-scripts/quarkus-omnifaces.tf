# Create repository
resource "github_repository" "quarkus_omnifaces" {
  name                   = "quarkus-omnifaces"
  description            = "Quarkus OmniFaces Extension"
  homepage_url           = "https://omnifaces.org/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["faces", "jsf", "omnifaces", "quarkus-extension", "quarkus"]
}

# Create team
resource "github_team" "quarkus_omnifaces" {
  name                      = "quarkiverse-omnifaces"
  description               = "omnifaces team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_omnifaces" {
  team_id    = github_team.quarkus_omnifaces.id
  repository = github_repository.quarkus_omnifaces.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_omnifaces" {
  for_each = { for tm in ["melloware"] : tm => tm }
  team_id  = github_team.quarkus_omnifaces.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_omnifaces" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_omnifaces.name
}

