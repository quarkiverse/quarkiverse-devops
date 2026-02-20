# Create repository
resource "github_repository" "quarkus_batik" {
  name                   = "quarkus-batik"
  description            = "Batik supports Scalable Vector Graphics (SVG) format for various purposes, such as display, generation or manipulation."
  homepage_url           = "https://xmlgraphics.apache.org/batik/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "svg", "graphics", "image"]
}

# Create team
resource "github_team" "quarkus_batik" {
  name                      = "quarkiverse-batik"
  description               = "batik team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_batik" {
  team_id    = github_team.quarkus_batik.id
  repository = github_repository.quarkus_batik.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_batik" {
  for_each = { for tm in ["melloware"] : tm => tm }
  team_id  = github_team.quarkus_batik.id
  username = each.value
  role     = "maintainer"
}
