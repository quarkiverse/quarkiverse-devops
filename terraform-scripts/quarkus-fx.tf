# Create repository
resource "github_repository" "quarkus_fx" {
  name                   = "quarkus-fx"
  description            = "Run Java FX on Quarkus"
  homepage_url           = "https://openjfx.io/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "quarkus", "javafx"]
}

# Create team
resource "github_team" "quarkus_fx" {
  name                      = "quarkiverse-fx"
  description               = "fx team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_fx" {
  team_id    = github_team.quarkus_fx.id
  repository = github_repository.quarkus_fx.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_fx" {
  for_each = { for tm in ["CodeSimcoe"] : tm => tm }
  team_id  = github_team.quarkus_fx.id
  username = each.value
  role     = "maintainer"
}
