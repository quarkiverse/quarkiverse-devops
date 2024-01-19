# Create repository
resource "github_repository" "quarkus_kiota" {
  name                   = "quarkus-kiota"
  description            = "Generate client SDKs using Kiota from OpenAPI descriptions"
  homepage_url           = "https://github.com/microsoft/kiota"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "kiota"]
}

# Create team
resource "github_team" "quarkus_kiota" {
  name                      = "quarkiverse-kiota"
  description               = "kiota team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_kiota" {
  team_id    = github_team.quarkus_kiota.id
  repository = github_repository.quarkus_kiota.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_kiota" {
  for_each = { for tm in ["andreaTP"] : tm => tm }
  team_id  = github_team.quarkus_kiota.id
  username = each.value
  role     = "maintainer"
}
