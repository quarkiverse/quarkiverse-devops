# Create repository
resource "github_repository" "quarkus_web_assets" {
  name                   = "quarkus-web-bundler"
  description            = "Provide processing and helpers for your web-app media (JS, CSS, SCSS)."
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "frontend", "renarde"]
}

# Create team
resource "github_team" "quarkus_web_assets" {
  name                      = "quarkiverse-web-assets"
  description               = "web-assets team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_web_assets" {
  team_id    = github_team.quarkus_web_assets.id
  repository = github_repository.quarkus_web_assets.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_web_assets" {
  for_each = { for tm in ["ia3andy", "mkouba", "phillip-kruger", "FroMage"] : tm => tm }
  team_id  = github_team.quarkus_web_assets.id
  username = each.value
  role     = "maintainer"
}
