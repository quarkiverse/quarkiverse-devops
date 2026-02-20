# Create repository
resource "github_repository" "quarkus_discord4j" {
  name                   = "quarkus-discord4j"
  description            = "A JVM-based REST/WS wrapper for the official Discord Bot API, written in Java"
  homepage_url           = "https://discord4j.com/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "discord"]
}

# Create team
resource "github_team" "quarkus_discord4j" {
  name                      = "quarkiverse-discord4j"
  description               = "discord4j team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_discord4j" {
  team_id    = github_team.quarkus_discord4j.id
  repository = github_repository.quarkus_discord4j.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_discord4j" {
  for_each = { for tm in ["gsmet"] : tm => tm }
  team_id  = github_team.quarkus_discord4j.id
  username = each.value
  role     = "maintainer"
}
