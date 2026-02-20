# Create repository
resource "github_repository" "quarkus_zanzibar" {
  name                   = "quarkus-zanzibar"
  description            = "Zanzibar style fine grained authorization"
  homepage_url           = "https://zanzibar.academy"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true

  topics = ["quarkus-extension", "zanzibar"]
}

# Create team
resource "github_team" "quarkus_zanzibar" {
  name                      = "quarkiverse-zanzibar"
  description               = "Quarkiverse team for the zanzibar Quarkus extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_zanzibar" {
  team_id    = github_team.quarkus_zanzibar.id
  repository = github_repository.quarkus_zanzibar.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_zanzibar" {
  for_each = { for tm in ["kdubb"] : tm => tm }
  team_id  = github_team.quarkus_zanzibar.id
  username = each.value
  role     = "maintainer"
}
