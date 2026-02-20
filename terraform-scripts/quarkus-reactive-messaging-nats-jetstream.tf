# Create repository
resource "github_repository" "quarkus_reactive_messaging_nats_jetstream" {
  name                   = "quarkus-reactive-messaging-nats-jetstream"
  description            = "Easily integrate to NATS.io JetStreams"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-reactive-messaging-nats-jetstream/dev/index.html"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "nats", "jetstream", "reactive-messaging"]
}

# Create team
resource "github_team" "quarkus_reactive_messaging_nats_jetstream" {
  name                      = "quarkiverse-reactive-messaging-nats-jetstream"
  description               = "Quarkiverse team for the Reactive Messaging NATS.io JetStream extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_reactive_messaging_nats_jetstream" {
  team_id    = github_team.quarkus_reactive_messaging_nats_jetstream.id
  repository = github_repository.quarkus_reactive_messaging_nats_jetstream.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_reactive_messaging_nats_jetstream" {
  for_each = { for tm in ["kjeldpaw"] : tm => tm }
  team_id  = github_team.quarkus_reactive_messaging_nats_jetstream.id
  username = each.value
  role     = "maintainer"
}
