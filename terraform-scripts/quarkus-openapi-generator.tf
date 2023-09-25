# Create repository
resource "github_repository" "quarkus_openapi_generator" {
  name                   = "quarkus-openapi-generator"
  description            = "OpenApi Generator - REST Client Generator"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_discussions        = true
  vulnerability_alerts   = true
  topics                 = ["openapi", "openapi-generator", "openapi-specification", "rest", "rest-client", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_openapi_generator" {
  name                      = "quarkiverse-openapi-generator"
  description               = "openapi-generator team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_openapi_generator" {
  team_id    = github_team.quarkus_openapi_generator.id
  repository = github_repository.quarkus_openapi_generator.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_openapi_generator" {
  for_each = { for tm in ["ricardozanini", "fjtirado", "hbelmiro", "carlesarnal"] : tm => tm }
  team_id  = github_team.quarkus_openapi_generator.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_openapi_generator" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_openapi_generator.name
}

# Add an admin collaborator to this repository
resource "github_repository_collaborator" "quarkus_openapi_generator" {
  repository = github_repository.quarkus_openapi_generator.name
  username   = "ricardozanini"
  permission = "admin"
}
