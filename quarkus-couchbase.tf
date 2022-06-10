# Create repository
resource "github_repository" "quarkus_couchbase" {
  name                   = "quarkus-couchbase"
  description            = "Couchbase is an award-winning distributed NoSQL cloud database."
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "couchbase"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
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
  for_each = { for tm in ["programmatix"] : tm => tm }
  team_id  = github_team.quarkus_couchbase.id
  username = each.value
  role     = "maintainer"
}
