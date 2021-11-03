# Create repository
resource "github_repository" "quarkus_unleash" {
  name                   = "quarkus-unleash"
  description            = "Quarkus Extension for Social Style Date and Time Formatting"
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
resource "github_team" "quarkus_unleash" {
  name                      = "quarkiverse-unleash"
  description               = "Quarkiverse team for the unleash extension"
  create_default_maintainer = false
  privacy                   = "closed"
}

# Add team to repository
resource "github_team_repository" "quarkus_unleash" {
  team_id    = github_team.quarkus_unleash.id
  repository = github_repository.quarkus_unleash.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_unleash" {
  for_each = { for tm in ["andrejpetras"] : tm => tm }
  team_id  = github_team.quarkus_unleash.id
  username = each.value
  role     = "maintainer"
}
