# Create repository
resource "github_repository" "quarkus_mailpit" {
  name                   = "quarkus-mailpit"
  description            = "Email and SMTP testing tool with API for developers"
  homepage_url           = "https://github.com/axllent/mailpit"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "email", "smtp-server"]
}

# Create team
resource "github_team" "quarkus_mailpit" {
  name                      = "quarkiverse-mailpit"
  description               = "mailpit team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mailpit" {
  team_id    = github_team.quarkus_mailpit.id
  repository = github_repository.quarkus_mailpit.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mailpit" {
  for_each = { for tm in ["melloware"] : tm => tm }
  team_id  = github_team.quarkus_mailpit.id
  username = each.value
  role     = "maintainer"
}
