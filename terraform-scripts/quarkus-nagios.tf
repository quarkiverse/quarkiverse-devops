# Create repository
resource "github_repository" "quarkus_nagios" {
  name                   = "quarkus-nagios"
  description            = "Health endpoints in Nagios format"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-nagios/dev/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "nagios", "observability"]
}

# Create team
resource "github_team" "quarkus_nagios" {
  name                      = "quarkiverse-nagios"
  description               = "nagios team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_nagios" {
  team_id    = github_team.quarkus_nagios.id
  repository = github_repository.quarkus_nagios.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_nagios" {
  for_each = { for tm in ["derari"] : tm => tm }
  team_id  = github_team.quarkus_nagios.id
  username = each.value
  role     = "maintainer"
}
