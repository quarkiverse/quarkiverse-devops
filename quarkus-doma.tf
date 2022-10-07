# Create repository
resource "github_repository" "quarkus_doma" {
  name                   = "quarkus-doma"
  description            = "Quarkus Doma Extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["java", "sql", "orm", "annotation-processing", "quarkus-extension", "domaframework"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_doma" {
  name                      = "quarkiverse-doma"
  description               = "Quarkiverse team for the Doma extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_doma" {
  team_id    = github_team.quarkus_doma.id
  repository = github_repository.quarkus_doma.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_doma" {
  for_each = { for tm in ["nakamura-to"] : tm => tm }
  team_id  = github_team.quarkus_doma.id
  username = each.value
  role     = "maintainer"
}
