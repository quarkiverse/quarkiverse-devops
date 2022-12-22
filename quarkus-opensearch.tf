# Create repository
resource "github_repository" "quarkus_opensearch" {
  name                   = "quarkus-opensearch"
  description            = "OpenSearch extension for connecting to an OpenSearch cluster"
  homepage_url           = "https://opensearch.org/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["elasticsearch", "opensearch", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_opensearch" {
  name                      = "quarkiverse-opensearch"
  description               = "opensearch team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_opensearch" {
  team_id    = github_team.quarkus_opensearch.id
  repository = github_repository.quarkus_opensearch.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_opensearch" {
  for_each = { for tm in ["sboeckelmann", "loicmathieu"] : tm => tm }
  team_id  = github_team.quarkus_opensearch.id
  username = each.value
  role     = "maintainer"
}