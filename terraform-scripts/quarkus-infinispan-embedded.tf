# Create repository
resource "github_repository" "quarkus_infinispan_embedded" {
  name                   = "quarkus-infinispan-embedded"
  description            = "A Quarkus extension for embedded Infinispan integrates in-memory data grid features directly into Quarkus applications, enabling efficient caching and data storage."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-infinispan-embedded/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_discussions        = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "infinispan", "infinispan-embedded", "caching", "distributed-caching"]
}

# Create team
resource "github_team" "quarkus_infinispan_embedded" {
  name                      = "quarkiverse-infinispan-embedded"
  description               = "infinispan-embedded team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_infinispan_embedded" {
  team_id    = github_team.quarkus_infinispan_embedded.id
  repository = github_repository.quarkus_infinispan_embedded.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_infinispan_embedded" {
  for_each = { for tm in ["karesti", "wburns", "ryanemerson", "tristantarrant"] : tm => tm }
  team_id  = github_team.quarkus_infinispan_embedded.id
  username = each.value
  role     = "maintainer"
}
