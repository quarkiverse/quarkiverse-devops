# Create repository
resource "github_repository" "quarkus_tika" {
  name                   = "quarkus-tika"
  description            = "Quarkus Tika extension"
  homepage_url           = "https://tika.apache.org/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "content-detection", "tika"]
}

# Create team
resource "github_team" "quarkus_tika" {
  name                      = "quarkiverse-tika"
  description               = "Quarkiverse team for the Tika extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_tika" {
  team_id    = github_team.quarkus_tika.id
  repository = github_repository.quarkus_tika.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_tika" {
  for_each = { for tm in ["sberyozkin", "tpodg", "zhfeng", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_tika.id
  username = each.value
  role     = "maintainer"
}
