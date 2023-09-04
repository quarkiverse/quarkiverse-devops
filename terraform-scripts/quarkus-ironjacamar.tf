# Create repository
resource "github_repository" "quarkus_ironjacamar" {
  name                   = "quarkus-ironjacamar"
  description            = "IronJacamar is an implementation of the Jakarta Connector Architecture specification"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-ironjacamar/dev/index.html"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "jca"]
}

# Create team
resource "github_team" "quarkus_ironjacamar" {
  name                      = "quarkiverse-ironjacamar"
  description               = "ironjacamar team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_ironjacamar" {
  team_id    = github_team.quarkus_ironjacamar.id
  repository = github_repository.quarkus_ironjacamar.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_ironjacamar" {
  for_each = { for tm in ["gastaldi", "vsevel"] : tm => tm }
  team_id  = github_team.quarkus_ironjacamar.id
  username = each.value
  role     = "maintainer"
}
