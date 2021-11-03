# Create repository
resource "github_repository" "quarkus_lucene" {
  name                   = "quarkus-lucene"
  description            = "Quarkus Lucene Extension"
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
resource "github_team" "quarkus_lucene" {
  name                      = "quarkiverse-lucene"
  description               = "Quarkiverse team for the lucene extension"
  create_default_maintainer = false
  privacy                   = "closed"
}

# Add team to repository
resource "github_team_repository" "quarkus_lucene" {
  team_id    = github_team.quarkus_lucene.id
  repository = github_repository.quarkus_lucene.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_lucene" {
  for_each = { for tm in ["gustavonalle"] : tm => tm }
  team_id  = github_team.quarkus_lucene.id
  username = each.value
  role     = "maintainer"
}
