# Create repository
resource "github_repository" "quarkus_sqlite4j" {
  name                   = "quarkus-jdbc-sqlite4j"
  description            = "SQLite driver for Quarkus with Agroal in pure Java built on SQLite4j"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-sqlite4j/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["jdbc", "sqlite", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_sqlite4j" {
  name                      = "quarkiverse-jdbc-sqlite4j"
  description               = "sqlite4j team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_sqlite4j" {
  team_id    = github_team.quarkus_sqlite4j.id
  repository = github_repository.quarkus_sqlite4j.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_sqlite4j" {
  for_each = { for tm in ["andreaTP"] : tm => tm }
  team_id  = github_team.quarkus_sqlite4j.id
  username = each.value
  role     = "maintainer"
}
