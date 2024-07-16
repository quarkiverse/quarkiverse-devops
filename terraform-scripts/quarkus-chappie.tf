# Create repository
resource "github_repository" "quarkus_chappie" {
  name                   = "quarkus-chappie"
  description            = "AI Assistant for Quarkus Dev Mode"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-chappie/dev/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "ai", "chappie"]
}

# Create team
resource "github_team" "quarkus_chappie" {
  name                      = "quarkiverse-chappie"
  description               = "chappie team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_chappie" {
  team_id    = github_team.quarkus_chappie.id
  repository = github_repository.quarkus_chappie.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_chappie" {
  for_each = { for tm in ["phillip-kruger"] : tm => tm }
  team_id  = github_team.quarkus_chappie.id
  username = each.value
  role     = "maintainer"
}
