# Create repository
resource "github_repository" "quarkus_jgit" {
  name                   = "quarkus-jgit"
  description            = "Quarkus JGit extension"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_jgit" {
  name                      = "quarkiverse-jgit"
  description               = "Quarkiverse team for the JGit extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jgit" {
  team_id    = github_team.quarkus_jgit.id
  repository = github_repository.quarkus_jgit.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jgit" {
  for_each = { for tm in ["gastaldi"] : tm => tm }
  team_id  = github_team.quarkus_jgit.id
  username = each.value
  role     = "maintainer"
}
