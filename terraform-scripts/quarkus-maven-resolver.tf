# Create repository
resource "github_repository" "quarkus_maven_resolver" {
  name                   = "quarkus-maven-resolver"
  description            = "An extension providing a Maven resolver implementation from the Quarkus core bootstrap project"
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
resource "github_team" "quarkus_maven_resolver" {
  name                      = "quarkiverse-maven-resolver"
  description               = "Quarkiverse team for the maven resolver extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_maven_resolver" {
  team_id    = github_team.quarkus_maven_resolver.id
  repository = github_repository.quarkus_maven_resolver.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_maven_resolver" {
  for_each = { for tm in ["aloubyansky"] : tm => tm }
  team_id  = github_team.quarkus_maven_resolver.id
  username = each.value
  role     = "maintainer"
}
