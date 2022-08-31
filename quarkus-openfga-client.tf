# Create repository
resource "github_repository" "quarkus_openfga_client" {
  name                   = "quarkus-openfga-client"
  description            = "Quarkus extension for OpenFGA support"
  homepage_url           = "https://openfga.dev"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["openfga", "zanzibar", "quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_openfga_client" {
  name                      = "quarkiverse-openfga-client"
  description               = "Quarkiverse team for the openfga-client extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_openfga_client" {
  team_id    = github_team.quarkus_openfga_client.id
  repository = github_repository.quarkus_openfga_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_openfga_client" {
  for_each = { for tm in ["kdubb"] : tm => tm }
  team_id  = github_team.quarkus_openfga_client.id
  username = each.value
  role     = "maintainer"
}

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_openfga_client" {
  for_each = { for app in [local.applications.stale] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_openfga_client.name
}
