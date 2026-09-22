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
    "AZURE_CLIENT_ID"       = "113bfe24-3b5a-47fa-9e1a-924053c04e22"
    "AZURE_TENANT_ID"       = "82fe215a-0af5-404a-9161-206e0bdad999"
    "AZURE_SUBSCRIPTION_ID" = "c7844e91-b11d-4a7f-ac6f-996308fbcdb9"
  }
  repository    = github_repository.quarkus_azure_services.name
  environment   = "ci"
  variable_name = each.key
  value         = each.value
}
