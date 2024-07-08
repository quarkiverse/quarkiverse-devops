# Create repository
resource "github_repository" "quarkus_cxf" {
  name                   = "quarkus-cxf"
  description            = "Quarkus CXF Extension to support SOAP based web services."
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_discussions        = true
  vulnerability_alerts   = true

  topics = ["quarkus-extension"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_cxf" {
  name                      = "quarkiverse-cxf"
  description               = "Quarkiverse team for the CXF extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_cxf" {
  team_id    = github_team.quarkus_cxf.id
  repository = github_repository.quarkus_cxf.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_cxf" {
  for_each = { for tm in ["dufoli", "Dufgui", "shumonsharif", "ppalaga", "famod", "JiriOndrusek"] : tm => tm }
  team_id  = github_team.quarkus_cxf.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_cxf" {
  for_each = { for app in [local.applications.lgtm, local.applications.renovate] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_cxf.name
}
