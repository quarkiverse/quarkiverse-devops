# Create repository
resource "github_repository" "quarkus_config_extensions" {
  name                   = "quarkus-config-extensions"
  description            = "Quarkus extensions to support Microprofile Config Sources"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_config_extensions" {
  name                      = "quarkiverse-config-extensions"
  description               = "Quarkiverse team for the config-extensions extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_config_extensions" {
  team_id    = github_team.quarkus_config_extensions.id
  repository = github_repository.quarkus_config_extensions.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_config_extensions" {
  for_each = { for tm in ["radcortez"] : tm => tm }
  team_id  = github_team.quarkus_config_extensions.id
  username = each.value
  role     = "maintainer"
}

# Add admin users
resource "github_repository_collaborator" "quarkus_config_extensions" {
  for_each   = { for tm in ["radcortez"] : tm => tm }
  repository = github_repository.quarkus_config_extensions.name
  username   = each.value
  permission = "admin"
}
