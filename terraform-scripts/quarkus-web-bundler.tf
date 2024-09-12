# Create repository
resource "github_repository" "quarkus_web_assets" {
  name                   = "quarkus-web-bundler"
  description            = "Create full-stack web apps quickly and easily with this Quarkus extension. It offers zero-configuration bundling for your web app scripts (JS, JSX, TS, TSX), dependencies (jQuery, React, htmx, etc.), and styles (CSS, SCSS, SASS)."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-web-bundler/dev/index.html"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "frontend", "web", "full-stack", "js", "scss", "sass", "bundle", "esbuild", "mvnpm", "webjars", "typescript", "javascript", "assets"]
}

# Create team
resource "github_team" "quarkus_web_assets" {
  name                      = "quarkiverse-web-bundler"
  description               = "web-assets team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_web_assets" {
  team_id    = github_team.quarkus_web_assets.id
  repository = github_repository.quarkus_web_assets.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_web_assets" {
  for_each = { for tm in ["ia3andy", "mkouba", "phillip-kruger", "FroMage", "edewit"] : tm => tm }
  team_id  = github_team.quarkus_web_assets.id
  username = each.value
  role     = "maintainer"
}
