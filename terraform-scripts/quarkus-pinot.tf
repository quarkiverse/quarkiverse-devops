# Create repository
resource "github_repository" "quarkus_apache_pinot" {
  name                   = "quarkus-pinot"
  description            = "Quarkus Apache Pinot extension"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_apache_pinot" {
  name                      = "quarkiverse-pinot"
  description               = "Quarkiverse team for the Apache Pinot extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_apache_pinot" {
  team_id    = github_team.quarkus_apache_pinot.id
  repository = github_repository.quarkus_apache_pinot.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_apache_pinot" {
  for_each = { for tm in ["loicmathieu"] : tm => tm }
  team_id  = github_team.quarkus_apache_pinot.id
  username = each.value
  role     = "maintainer"
}
