# Create repository
resource "github_repository" "quarkus_homeassistant" {
  name                   = "quarkus-homeassistant"
  description            = "Quarkus bringing developer joy to HomeAssistant"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-homeassistant/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "homeassistant", "iot"]
}

# Create team
resource "github_team" "quarkus_homeassistant" {
  name                      = "quarkiverse-homeassistant"
  description               = "HomeAssistant team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_homeassistant" {
  team_id    = github_team.quarkus_homeassistant.id
  repository = github_repository.quarkus_homeassistant.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_homeassistant" {
  for_each = { for tm in ["maxandersen"] : tm => tm }
  team_id  = github_team.quarkus_homeassistant.id
  username = each.value
  role     = "maintainer"
}
