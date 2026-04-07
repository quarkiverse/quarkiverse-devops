# Create repository
resource "github_repository" "quarkus_jdbi" {
  name                   = "quarkus-jdbi"
  description            = "Jdbi provides convenient, idiomatic access to relational data in Java"
  homepage_url           = "https://jdbi.org/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_jdbi" {
  name           = "quarkiverse-jdbi"
  description    = "jdbi team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jdbi" {
  team_id    = github_team.quarkus_jdbi.id
  repository = github_repository.quarkus_jdbi.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jdbi" {
  for_each = { for tm in ["smil2k", "Eng-Fouad"] : tm => tm }
  team_id  = github_team.quarkus_jdbi.id
  username = each.value
  role     = "maintainer"
}


