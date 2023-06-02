# Create repository
resource "github_repository" "quarkus_azure_services" {
  name                   = "quarkus-azure-services"
  description            = "Quarkus extensions for Azure services"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "quarkus", "azure"]
}

# Create team
resource "github_team" "quarkus_azure_services" {
  name                      = "quarkiverse-azure-services"
  description               = "Quarkiverse team for the Azure services extensions"
  create_default_maintainer = false
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
  for_each = { for tm in ["m-reza-rahman", "edburns", "majguo", "zhengchang907", "galiacheng", "agoncal", "backwind1233"] : tm => tm }
  team_id  = github_team.quarkus_azure_services.id
  username = each.value
  role     = "maintainer"
}

# Create CI environment secrets
resource "github_actions_environment_secret" "quarkus_azure_services" {
  for_each = {
    "AZURE_CLIENT_ID"       = "foo"
    "AZURE_TENANT_ID"       = "bar"
    "AZURE_SUBSCRIPTION_ID" = "blah"
  }
  repository      = github_repository.quarkus_azure_services.name
  environment     = "ci"
  secret_name     = each.key
  plaintext_value = each.value
}
