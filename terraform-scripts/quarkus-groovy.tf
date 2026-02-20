# Create repository
resource "github_repository" "quarkus_groovy" {
  name                   = "quarkus-groovy"
  description            = "Groovy support in Quarkus"
  homepage_url           = "https://groovy.apache.org/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_discussions        = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "groovy"]
}

# Create team
resource "github_team" "quarkus_groovy" {
  name                      = "quarkiverse-groovy"
  description               = "groovy team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_groovy" {
  team_id    = github_team.quarkus_groovy.id
  repository = github_repository.quarkus_groovy.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_groovy" {
  for_each = { for tm in ["essobedo"] : tm => tm }
  team_id  = github_team.quarkus_groovy.id
  username = each.value
  role     = "maintainer"
}
