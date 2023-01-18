# Create repository
resource "github_repository" "quarkus_jooq" {
  name                   = "quarkus-jooq"
  description            = "Quarkus Jooq Extension"
  archive_on_destroy     = true
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
resource "github_team" "quarkus_jooq" {
  name                      = "quarkiverse-jooq"
  description               = "Quarkiverse team for the jooq extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jooq" {
  team_id    = github_team.quarkus_jooq.id
  repository = github_repository.quarkus_jooq.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jooq" {
  for_each = { for tm in ["angrymango", "ranjanashish"] : tm => tm }
  team_id  = github_team.quarkus_jooq.id
  username = each.value
  role     = "maintainer"
}
