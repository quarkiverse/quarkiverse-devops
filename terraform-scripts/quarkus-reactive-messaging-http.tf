# Create repository
resource "github_repository" "quarkus_reactive_messaging_http" {
  name                   = "quarkus-reactive-messaging-http"
  description            = "Connect to HTTP or Web Socket and expose HTTP or Web Socket endpoints for Reactive Messaging"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_reactive_messaging_http" {
  name                      = "quarkiverse-reactive-messaging-http"
  description               = "Quarkiverse team for the Reactive Messaging HTTP extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_reactive_messaging_http" {
  team_id    = github_team.quarkus_reactive_messaging_http.id
  repository = github_repository.quarkus_reactive_messaging_http.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_reactive_messaging_http" {
  for_each = { for tm in ["michalszynkiewicz", "ricardozanini", "cescoffier", "hbelmiro", "fjtirado"] : tm => tm }
  team_id  = github_team.quarkus_reactive_messaging_http.id
  username = each.value
  role     = "maintainer"
}
