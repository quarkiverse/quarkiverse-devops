# Create repository
resource "github_repository" "quarkus_ci_extensions" {
  name                   = "quarkus-ci-extensions"
  description            = "Quarkus extensions for generating CI related pipelines / workflows"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_ci_extensions" {
  name                      = "quarkiverse-ci-extensions"
  description               = "Quarkiverse team for the ci-extensions extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_ci_extensions" {
  team_id    = github_team.quarkus_ci_extensions.id
  repository = github_repository.quarkus_ci_extensions.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_ci_extensions" {
  for_each = { for tm in ["iocanel"] : tm => tm }
  team_id  = github_team.quarkus_ci_extensions.id
  username = each.value
  role     = "maintainer"
}