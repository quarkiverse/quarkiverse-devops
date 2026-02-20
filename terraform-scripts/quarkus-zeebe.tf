# Create repository
resource "github_repository" "quarkus_zeebe" {
  name                   = "quarkus-zeebe"
  description            = "Camunda Platform 8 (Zeebe) Quarkus extension"
  homepage_url           = "https://camunda.com/platform"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true

  topics = ["camunda", "quarkus-extension", "zeebe"]
}

# Create team
resource "github_team" "quarkus_zeebe" {
  name                      = "quarkiverse-zeebe"
  description               = "Quarkiverse team for the Camunda Zeebe Quarkus extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_zeebe" {
  team_id    = github_team.quarkus_zeebe.id
  repository = github_repository.quarkus_zeebe.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_zeebe" {
  for_each = { for tm in ["andrejpetras", "nh2297"] : tm => tm }
  team_id  = github_team.quarkus_zeebe.id
  username = each.value
  role     = "maintainer"
}
