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
  for_each = { for tm in ["marko-bekhta"] : tm => tm }
  team_id  = github_team.quarkus_hibernate_search_extras.id
  username = each.value
  role     = "maintainer"
}

# Add outside collaborators to the repository
resource "github_repository_collaborator" "quarkus_hibernate_search_extras" {
  for_each   = { for tm in ["yrodiere"] : tm => tm }
  repository = github_repository.quarkus_hibernate_search_extras.name
  username   = each.value
  permission = "push"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_hibernate_search_extras" {
  for_each = { for app in [local.applications.lgtm, local.applications.sync2jira_redhat] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_hibernate_search_extras.name
}
