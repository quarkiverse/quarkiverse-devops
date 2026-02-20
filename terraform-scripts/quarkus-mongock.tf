# Create repository
resource "github_repository" "quarkus_mongock" {
  name                   = "quarkus-mongock"
  description            = "Allows mongock database migrations for MongoDB to be executed during Quarkus startup"
  homepage_url           = "https://mongock.io/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "mongock"]
}

# Create team
resource "github_team" "quarkus_mongock" {
  name                      = "quarkiverse-mongock"
  description               = "mongock team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mongock" {
  team_id    = github_team.quarkus_mongock.id
  repository = github_repository.quarkus_mongock.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mongock" {
  for_each = { for tm in ["tms0"] : tm => tm }
  team_id  = github_team.quarkus_mongock.id
  username = each.value
  role     = "maintainer"
}
