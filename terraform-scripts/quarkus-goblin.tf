# Create repository
resource "github_repository" "quarkus_goblin" {
  name                   = "quarkus-goblin"
  description            = "Chaos engineering for Quarkus: inject latency, exceptions, forced HTTP statuses and simulated dependency degradation into REST endpoints during development"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-goblin/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "chaos-engineering", "chaos-monkey", "quarkus", "java", "resilience", "testing"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_goblin" {
  repository = github_repository.quarkus_goblin.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_goblin" {
  name           = "quarkiverse-goblin"
  description    = "goblin team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_goblin" {
  team_id    = github_team.quarkus_goblin.id
  repository = github_repository.quarkus_goblin.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_goblin" {
  for_each = { for tm in ["ErwanLT"] : tm => tm }
  team_id  = github_team.quarkus_goblin.id
  username = each.value
  role     = "maintainer"
}
