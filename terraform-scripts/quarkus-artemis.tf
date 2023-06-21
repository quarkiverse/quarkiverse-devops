# Create repository
resource "github_repository" "quarkus_artemis" {
  name                   = "quarkus-artemis"
  description            = "Quarkus Artemis extensions"
  allow_auto_merge       = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_artemis" {
  name                      = "quarkiverse-artemis"
  description               = "Quarkiverse team for the Artemis extensions"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_artemis" {
  team_id    = github_team.quarkus_artemis.id
  repository = github_repository.quarkus_artemis.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_artemis" {
  for_each = { for tm in ["middagj", "turing85", "zhfeng", "louisa-fr"] : tm => tm }
  team_id  = github_team.quarkus_artemis.id
  username = each.value
  role     = "maintainer"
}
