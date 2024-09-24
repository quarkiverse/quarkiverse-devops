# Create repository
resource "github_repository" "quarkus_couchbase" {
  name                   = "quarkus-couchbase"
  description            = "Couchbase is an award-winning distributed NoSQL cloud database."
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "couchbase"]
}

# Create team
resource "github_team" "quarkus_couchbase" {
  name                      = "quarkiverse-couchbase"
  description               = "couchbase team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_couchbase" {
  team_id    = github_team.quarkus_couchbase.id
  repository = github_repository.quarkus_couchbase.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_couchbase" {
  for_each = { for tm in ["programmatix", "emilienbev", "raycardillo"] : tm => tm }
  team_id  = github_team.quarkus_couchbase.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_couchbase" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_couchbase.name
}



