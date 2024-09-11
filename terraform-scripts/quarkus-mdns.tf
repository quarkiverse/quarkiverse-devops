# Create repository
resource "github_repository" "quarkus_mdns" {
  name                   = "quarkus-mdns"
  description            = "Quarkus mDNS extension - Multicast Domain Name System"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-mdns/2.0.0"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "mdns", "bonjour", "discovery"]
}

# Create team
resource "github_team" "quarkus_mdns" {
  name                      = "quarkiverse-mdns"
  description               = "mdns team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mdns" {
  team_id    = github_team.quarkus_mdns.id
  repository = github_repository.quarkus_mdns.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mdns" {
  for_each = { for tm in ["melloware"] : tm => tm }
  team_id  = github_team.quarkus_mdns.id
  username = each.value
  role     = "maintainer"
}
