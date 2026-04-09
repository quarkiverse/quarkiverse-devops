# Create repository
resource "github_repository" "quarkus_openapi_generator" {
  name                   = "quarkus-openapi-generator"
  description            = "OpenAPI Generator - REST Client Generator"
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
  name           = "quarkiverse-openapi-generator"
  description    = "openapi-generator team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_openapi_generator" {
  team_id    = github_team.quarkus_openapi_generator.id
  repository = github_repository.quarkus_openapi_generator.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_openapi_generator" {
  for_each = { for tm in ["ricardozanini", "fjtirado", "hbelmiro", "carlesarnal", "gmunozfe", "wmedvede"] : tm => tm }
  team_id  = github_team.quarkus_openapi_generator.id
  username = each.value
  role     = "maintainer"
}

# Add an admin collaborator to this repository
resource "github_repository_collaborator" "quarkus_openapi_generator" {
  repository = github_repository.quarkus_openapi_generator.name
  username   = "ricardozanini"
  permission = "admin"
}

resource "github_actions_organization_secret_repository" "quarkus_openapi_generator" {
  for_each      = { for k in [local.secrets.surge_token] : k => k }
  secret_name   = each.value
  repository_id = github_repository.quarkus_openapi_generator.repo_id
}
