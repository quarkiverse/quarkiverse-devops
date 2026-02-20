# Create repository
resource "github_repository" "quarkus_playwright" {
  name                   = "quarkus-playwright"
  description            = "Playwright enables reliable end-to-end testing for modern web apps"
  homepage_url           = "https://playwright.dev/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_playwright" {
  name                      = "quarkiverse-playwright"
  description               = "playwright team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_playwright" {
  team_id    = github_team.quarkus_playwright.id
  repository = github_repository.quarkus_playwright.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_playwright" {
  for_each = { for tm in ["ia3andy", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_playwright.id
  username = each.value
  role     = "maintainer"
}
