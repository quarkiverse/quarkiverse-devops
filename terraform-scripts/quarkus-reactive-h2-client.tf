# Create repository
resource "github_repository" "quarkus_reactive_h2_client" {
  name                   = "quarkus-reactive-h2-client"
  description            = "Reactive H2 client for Quarkus"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "h2", "reactive"]
}

# Create team
resource "github_team" "quarkus_reactive_h2_client" {
  name                      = "quarkiverse-reactive-h2-client"
  description               = "reactive-h2-client team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_reactive_h2_client" {
  team_id    = github_team.quarkus_reactive_h2_client.id
  repository = github_repository.quarkus_reactive_h2_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_reactive_h2_client" {
  for_each = { for tm in ["benstonezhang"] : tm => tm }
  team_id  = github_team.quarkus_reactive_h2_client.id
  username = each.value
  role     = "maintainer"
}