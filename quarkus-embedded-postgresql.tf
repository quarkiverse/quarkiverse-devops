# Create repository
resource "github_repository" "quarkus_embedded_postgresql" {
  name                   = "quarkus-embedded-postgresql"
  description            = "A cool description"
  homepage_url           = "https://github.com/zonkyio/embedded-postgres"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "postgresql", "zonkyo", "embedded-postgresql", "embedded-db", "embedded-database"]
}

# Create team
resource "github_team" "quarkus_embedded_postgresql" {
  name                      = "quarkiverse-embedded-postgresql"
  description               = "embedded-postgresql team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_embedded_postgresql" {
  team_id    = github_team.quarkus_embedded_postgresql.id
  repository = github_repository.quarkus_embedded_postgresql.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_embedded_postgresql" {
  for_each = { for tm in ["fjtirado", "cristianonicolai"] : tm => tm }
  team_id  = github_team.quarkus_embedded_postgresql.id
  username = each.value
  role     = "maintainer"
}