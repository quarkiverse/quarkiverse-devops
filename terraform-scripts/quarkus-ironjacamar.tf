# Create repository
resource "github_repository" "quarkus_ironjacamar" {
  name                   = "quarkus-ironjacamar"
  description            = "IronJacamar is an implementation of the Jakarta Connectors Architecture (JCA) specification"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-ironjacamar/dev/index.html"
  allow_update_branch    = true
  allow_auto_merge       = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "jca"]
}

resource "github_repository_vulnerability_alerts" "quarkus_ironjacamar" {
  repository = github_repository.quarkus_ironjacamar.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_ironjacamar" {
  name           = "quarkiverse-ironjacamar"
  description    = "ironjacamar team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_ironjacamar" {
  team_id    = github_team.quarkus_ironjacamar.id
  repository = github_repository.quarkus_ironjacamar.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_ironjacamar" {
  for_each = { for tm in ["gastaldi", "vsevel"] : tm => tm }
  team_id  = github_team.quarkus_ironjacamar.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_ironjacamar" {
  for_each = { for app in [local.applications.renovate] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_ironjacamar.name
}
