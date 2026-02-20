# Create repository
resource "github_repository" "quarkus_jasperreports" {
  name                   = "quarkus-jasperreports"
  description            = "Print reports created using JasperReports using the Java API"
  homepage_url           = "https://community.jaspersoft.com/project/jasperreports-library"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_discussions        = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "jasperreports"]
}

# Create team
resource "github_team" "quarkus_jasperreports" {
  name                      = "quarkiverse-jasperreports"
  description               = "jasperreports team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jasperreports" {
  team_id    = github_team.quarkus_jasperreports.id
  repository = github_repository.quarkus_jasperreports.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jasperreports" {
  for_each = { for tm in ["Postremus", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_jasperreports.id
  username = each.value
  role     = "maintainer"
}
