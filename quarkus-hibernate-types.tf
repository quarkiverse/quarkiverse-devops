# Create repository
resource "github_repository" "quarkus_hibernate_types" {
  name                   = "quarkus-hibernate-types"
  description            = "Quarkus Extension based on Hibernate Types (https://github.com/vladmihalcea/hibernate-types)"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_hibernate_types" {
  name                      = "quarkiverse-hibernate_types"
  description               = "Quarkiverse team for the hibernate_types extension"
  create_default_maintainer = false
  privacy                   = "closed"
}

# Add team to repository
resource "github_team_repository" "quarkus_hibernate_types" {
  team_id    = github_team.quarkus_hibernate_types.id
  repository = github_repository.quarkus_hibernate_types.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_hibernate_types" {
  for_each = { for tm in ["andrejpetras"] : tm => tm }
  team_id  = github_team.quarkus_hibernate_types.id
  username = each.value
  role     = "maintainer"
}
