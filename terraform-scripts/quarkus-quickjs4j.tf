# Create repository
resource "github_repository" "quarkus_quickjs4j" {
  name                   = "quarkus-quickjs4j"
  description            = "A secure and efficient way to execute JavaScript within Java"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-quickjs4j/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["js", "quickjs4j", "sandbox", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_quickjs4j" {
  name                      = "quarkiverse-quickjs4j"
  description               = "quickjs4j team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_quickjs4j" {
  team_id    = github_team.quarkus_quickjs4j.id
  repository = github_repository.quarkus_quickjs4j.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_quickjs4j" {
  for_each = { for tm in ["EricWittmann", "andreaTP"] : tm => tm }
  team_id  = github_team.quarkus_quickjs4j.id
  username = each.value
  role     = "maintainer"
}
