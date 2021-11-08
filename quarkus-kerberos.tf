# Create repository
resource "github_repository" "quarkus_kerberos" {
  name                   = "quarkus-kerberos"
  description            = "Quarkus Kerberos extension"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["authentication", "quarkus-extension"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_kerberos" {
  name                      = "quarkiverse-kerberos"
  description               = "Quarkiverse team for the kerberos extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_kerberos" {
  team_id    = github_team.quarkus_kerberos.id
  repository = github_repository.quarkus_kerberos.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_kerberos" {
  for_each = { for tm in ["cescoffier", "sberyozkin", "stuartwdouglas"] : tm => tm }
  team_id  = github_team.quarkus_kerberos.id
  username = each.value
  role     = "maintainer"
}
