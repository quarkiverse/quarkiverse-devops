# Create repository
resource "github_repository" "quarkus_systemd_notify" {
  name                   = "quarkus-systemd-notify"
  description            = "This project demonstrates integrating systemd-notify with Quarkus"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "systemd-notify", "quarkus", "linux", "systemd"]
}

# Create team
resource "github_team" "quarkus_systemd_notify" {
  name                      = "quarkiverse-systemd-notify"
  description               = "systemd-notify team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_systemd_notify" {
  team_id    = github_team.quarkus_systemd_notify.id
  repository = github_repository.quarkus_systemd_notify.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_systemd_notify" {
  for_each = { for tm in ["Eng-Fouad"] : tm => tm }
  team_id  = github_team.quarkus_systemd_notify.id
  username = each.value
  role     = "maintainer"
}