# Create repository
resource "github_repository" "quarkus_open_feature" {
  name                   = "quarkus-open-feature"
  description            = "Feature Flagging Standard"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-open-feature/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "feature-flag"]
}

# Create team
resource "github_team" "quarkus_open_feature" {
  name                      = "quarkiverse-open-feature"
  description               = "open-feature team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_open_feature" {
  team_id    = github_team.quarkus_open_feature.id
  repository = github_repository.quarkus_open_feature.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_open_feature" {
  for_each = { for tm in ["rmanibus", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_open_feature.id
  username = each.value
  role     = "maintainer"
}
