# Create repository
resource "github_repository" "quarkus_banner" {
  name                   = "quarkus-banner"
  description            = "Generate a FIGlet ASCII-art startup banner at build time from a text and font"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-banner/dev/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "banner", "figlet", "ascii-art", "startup"]
}

resource "github_repository_vulnerability_alerts" "quarkus_banner" {
  repository = github_repository.quarkus_banner.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_banner" {
  name           = "quarkiverse-banner"
  description    = "banner team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_banner" {
  team_id    = github_team.quarkus_banner.id
  repository = github_repository.quarkus_banner.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_banner" {
  for_each = { for tm in ["eddiecarpenter"] : tm => tm }
  team_id  = github_team.quarkus_banner.id
  username = each.value
  role     = "maintainer"
}
