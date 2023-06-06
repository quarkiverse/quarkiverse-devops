# Create repository
resource "github_repository" "quarkus_hibernate_search_extras" {
  name                   = "quarkus-hibernate-search-extras"
  description            = "Quarkus Hibernate Search Extras extensions"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_hibernate_search_extras" {
  name                      = "quarkiverse-hibernate-search-extras"
  description               = "Quarkiverse team for the Hibernate Search Extras extensions"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_hibernate_search_extras" {
  team_id    = github_team.quarkus_hibernate_search_extras.id
  repository = github_repository.quarkus_hibernate_search_extras.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_hibernate_search_extras" {
  for_each = { for tm in ["yrodiere"] : tm => tm }
  team_id  = github_team.quarkus_hibernate_search_extras.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_hibernate_search_extras" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_hibernate_search_extras.name
}

# Enable branch protection so that we can use auto-merge (see https://github.com/quarkiverse/quarkiverse/issues/106)
resource "github_branch_protection" "quarkus_hibernate_search_extras_main" {
  repository_id = github_repository.quarkus_hibernate_search_extras.node_id

  pattern                         = "main"
  enforce_admins                  = false
  allows_deletions                = false
  require_conversation_resolution = true

  required_status_checks {
    strict   = false
    contexts = ["build"]
  }
}
