# Create repository
resource "github_repository" "quarkus_temporal" {
  name                   = "quarkus-temporal"
  description            = "Temporal (https://temporal.io/) is a developer-first, open source platform that ensures the successful execution of services and applications."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-temporal/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "workflow"]
}

# Create team
resource "github_team" "quarkus_temporal" {
  name                      = "quarkiverse-temporal"
  description               = "temporal team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_temporal" {
  team_id    = github_team.quarkus_temporal.id
  repository = github_repository.quarkus_temporal.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_temporal" {
  for_each = { for tm in ["rmanibus", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_temporal.id
  username = each.value
  role     = "maintainer"
}
