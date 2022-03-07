# Create repository
resource "github_repository" "quarkus_hibernate_search_extras" {
  name                   = "quarkus-hibernate-search-extras"
  description            = "Quarkus Hibernate Search Extras extensions"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
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
