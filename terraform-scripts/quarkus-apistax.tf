# Create repository
resource "github_repository" "quarkus_apistax" {
  name                   = "quarkus-apistax"
  description            = "Secure and reliable APIs for your common business needs"
  homepage_url           = "https://apistax.io/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension"]
}

resource "github_repository_vulnerability_alerts" "quarkus_apistax" {
  repository = github_repository.quarkus_apistax.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_apistax" {
  name           = "quarkiverse-apistax"
  description    = "apistax team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_apistax" {
  team_id    = github_team.quarkus_apistax.id
  repository = github_repository.quarkus_apistax.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_apistax" {
  for_each = { for tm in ["andlinger", "holzleitner"] : tm => tm }
  team_id  = github_team.quarkus_apistax.id
  username = each.value
  role     = "maintainer"
}

