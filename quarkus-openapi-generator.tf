# Create repository
resource "github_repository" "quarkus_openapi_generator" {
  name                   = "quarkus-openapi-generator"
  description            = "OpenApi Generator - REST Client Generator"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["openapi", "openapi-generator", "openapi-specification", "rest", "rest-client", "quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
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
  for_each = { for tm in ["ricardozanini", "evacchi", "fjtirado"] : tm => tm }
  team_id  = github_team.quarkus_openapi_generator.id
  username = each.value
  role     = "maintainer"
}
