# Create repository
resource "github_repository" "quarkus_azure_services" {
  name                   = "quarkus-azure-services"
  description            = "Quarkus extensions for Azure services"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_discussions        = true
  has_issues             = true
  topics                 = ["quarkus-extension", "quarkus", "azure"]
}

resource "github_repository_vulnerability_alerts" "quarkus_azure_services" {
  repository = github_repository.quarkus_azure_services.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_azure_services" {
  name           = "quarkiverse-azure-services"
  description    = "Quarkiverse team for the Azure services extensions"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_azure_services" {
  team_id    = github_team.quarkus_azure_services.id
  repository = github_repository.quarkus_azure_services.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_azure_services" {
  for_each = { for tm in ["edburns", "majguo", "galiacheng", "agoncal", "backwind1233"] : tm => tm }
  team_id  = github_team.quarkus_azure_services.id
  username = each.value
  role     = "maintainer"
}

# Create CI environment variables
resource "github_actions_environment_variable" "quarkus_azure_services" {
  for_each = {
    "AZURE_CLIENT_ID"       = "bd82fc0f-b99a-4a77-9d93-4d21b99e5533"
    "AZURE_TENANT_ID"       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    "AZURE_SUBSCRIPTION_ID" = "05887623-95c5-4e50-a71c-6e1c738794e2"
  }
  repository    = github_repository.quarkus_azure_services.name
  environment   = "ci"
  variable_name = each.key
  value         = each.value
}
