# Create repository
resource "github_repository" "quarkus_roq" {
  name                   = "quarkus-roq"
  description            = "An extension to generate/publish static pages from your Quarkus web-app"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "web", "static", "ssg", "site", "generator", "generate", "blog"]
}

# Create team
resource "github_team" "quarkus_roq" {
  name                      = "quarkiverse-roq"
  description               = "roq team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_roq" {
  team_id    = github_team.quarkus_roq.id
  repository = github_repository.quarkus_roq.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_roq" {
  for_each = { for tm in ["ia3andy", "melloware", "mcruzdev"] : tm => tm }
  team_id  = github_team.quarkus_roq.id
  username = each.value
  role     = "maintainer"
}
