# Create repository
resource "github_repository" "quarkus_angus_mail" {
  name                   = "quarkus-angus-mail"
  description            = "The Angus Mail project is a compatible implementation of the Jakarta Mail Specification 2.1+ providing a platform-independent and protocol-independent framework to build mail and messaging applications"
  homepage_url           = "https://eclipse-ee4j.github.io/angus-mail/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "mail", "smtp", "pop3", "imap", "quarkus"]
}

# Create team
resource "github_team" "quarkus_angus_mail" {
  name                      = "quarkiverse-angus-mail"
  description               = "angus-mail team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_angus_mail" {
  team_id    = github_team.quarkus_angus_mail.id
  repository = github_repository.quarkus_angus_mail.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_angus_mail" {
  for_each = { for tm in ["ppalaga"] : tm => tm }
  team_id  = github_team.quarkus_angus_mail.id
  username = each.value
  role     = "maintainer"
}
