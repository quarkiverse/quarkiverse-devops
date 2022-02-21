# Create repository
resource "github_repository" "quarkus_apicurio_registry_client" {
  name                   = "quarkus-apicurio-registry-client"
  description            = "Quarkus Extension for Apicurio Registry Client"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_apicurio_registry_client" {
  name                      = "quarkiverse-apicurio-registry-client"
  description               = "Quarkiverse team for the apicurio-registry-client extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_apicurio_registry_client" {
  team_id    = github_team.quarkus_apicurio_registry_client.id
  repository = github_repository.quarkus_apicurio_registry_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_apicurio_registry_client" {
  for_each = { for tm in ["famarting"] : tm => tm }
  team_id  = github_team.quarkus_apicurio_registry_client.id
  username = each.value
  role     = "maintainer"
}

# Create main branch
resource "github_branch" "quarkus_apicurio_registry_client" {
  repository = github_repository.quarkus_apicurio_registry_client.name
  branch     = "master"
}

# Set default branch
resource "github_branch_default" "quarkus_apicurio_registry_client" {
  repository = github_repository.quarkus_apicurio_registry_client.name
  branch     = github_branch.quarkus_apicurio_registry_client.branch
}