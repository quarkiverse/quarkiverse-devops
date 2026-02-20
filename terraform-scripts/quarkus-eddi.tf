# Create repository
resource "github_repository" "quarkus_eddi" {
  name                   = "quarkus-eddi"
  description            = "Scalable Open Source Chatbot Platform"
  homepage_url           = "https://docs.labs.ai/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_eddi" {
  name                      = "quarkiverse-eddi"
  description               = "eddi team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_eddi" {
  team_id    = github_team.quarkus_eddi.id
  repository = github_repository.quarkus_eddi.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_eddi" {
  for_each = { for tm in ["ginccc"] : tm => tm }
  team_id  = github_team.quarkus_eddi.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_eddi" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_eddi.name
}

