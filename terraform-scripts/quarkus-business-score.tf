# Create repository
resource "github_repository" "quarkus_business_score" {
  name                   = "quarkus-business-score"
  description            = "Collects application business score and detects zombies."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-business-score/dev/index.html"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_business_score" {
  name                      = "quarkiverse-business-score"
  description               = "business-score team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_business_score" {
  team_id    = github_team.quarkus_business_score.id
  repository = github_repository.quarkus_business_score.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_business_score" {
  for_each = { for tm in ["mkouba"] : tm => tm }
  team_id  = github_team.quarkus_business_score.id
  username = each.value
  role     = "maintainer"
}
