# Create repository
resource "github_repository" "quarkus_poi" {
  name                   = "quarkus-poi"
  description            = "Apache POI is an API to access Microsoft Office files. This extension provides integration with Apache POI"
  homepage_url           = "https://poi.apache.org/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "poi", "excel", "word", "powerpoint"]
}

# Create team
resource "github_team" "quarkus_poi" {
  name                      = "quarkiverse-poi"
  description               = "poi team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_poi" {
  team_id    = github_team.quarkus_poi.id
  repository = github_repository.quarkus_poi.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_poi" {
  for_each = { for tm in ["gastaldi", "tpodg", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_poi.id
  username = each.value
  role     = "maintainer"
}
