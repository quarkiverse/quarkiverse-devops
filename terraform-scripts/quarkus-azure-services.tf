# Create repository
resource "github_repository" "quarkus_azure_services" {
  name                   = "quarkus-azure-services"
  description            = "Quarkus extensions for Azure services"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_discussions        = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "quarkus", "azure"]
}

# Create team
resource "github_team" "quarkus_azure_services" {
  name                      = "quarkiverse-azure-services"
  description               = "Quarkiverse team for the Azure services extensions"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_azure_services" {
  team_id    = github_team.quarkus_azure_services.id
  repository = github_repository.quarkus_azure_services.name
  permission = "maintain"
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
    "AZURE_CLIENT_ID"       = "5afa9765-4baa-416d-a8dd-636f79aa1705"
    "AZURE_TENANT_ID"       = "63b290a9-485b-4dc9-a980-777b22108974"
    "AZURE_SUBSCRIPTION_ID" = "2be34c77-b1be-4417-b4b7-5419ba89dfed"
  }
  repository    = github_repository.quarkus_azure_services.name
  environment   = "ci"
  variable_name = each.key
  value         = each.value
}
