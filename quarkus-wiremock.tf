# Create repository
resource "github_repository" "quarkus_wiremock" {
  name                   = "quarkus-wiremock"
  description            = "Quarkus extension for launching an in-process Wiremock server"
  homepage_url           = "https://wiremock.org/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "wiremock"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_wiremock" {
  name                      = "quarkiverse-wiremock"
  description               = "wiremock team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_wiremock" {
  team_id    = github_team.quarkus_wiremock.id
  repository = github_repository.quarkus_wiremock.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_wiremock" {
  for_each = { for tm in ["Spanjer1"] : tm => tm }
  team_id  = github_team.quarkus_wiremock.id
  username = each.value
  role     = "maintainer"
}
