# Create repository
resource "github_repository" "quarkus_statiq" {
  name                   = "quarkus-roq"
  description            = "The Roq Static Site Generator allows to easily create a static website or blog using Quarkus super-powers."
  homepage_url           = "https://pages.quarkiverse.io/quarkus-roq/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_discussions        = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "web", "static", "ssg", "site", "generator", "generate", "blog", "hacktoberfest"]

  pages {
    build_type = "workflow"
    source {
      branch = "main"
      path   = "/"
    }
  }

}

# Create team
resource "github_team" "quarkus_statiq" {
  name                      = "quarkiverse-roq"
  description               = "roq team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_statiq" {
  team_id    = github_team.quarkus_statiq.id
  repository = github_repository.quarkus_statiq.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_statiq" {
  for_each = { for tm in ["ia3andy", "melloware", "mcruzdev"] : tm => tm }
  team_id  = github_team.quarkus_statiq.id
  username = each.value
  role     = "maintainer"
}

# Add admin users
resource "github_repository_collaborator" "quarkus_statiq" {
  for_each   = { for tm in ["ia3andy"] : tm => tm }
  repository = github_repository.quarkus_statiq.name
  username   = each.value
  permission = "admin"
}
