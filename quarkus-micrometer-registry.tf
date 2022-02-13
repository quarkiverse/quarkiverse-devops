# Create repository
resource "github_repository" "quarkus_micrometer_registry" {
  name                   = "quarkus-micrometer-registry"
  description            = "Quarkus extensions that pull together required/related dependencies for optional micrometer registries."
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  homepage_url           = "https://quarkiverse.github.io/quarkiverse-docs/quarkus-micrometer-registry/dev/"
  topics                 = ["hacktoberfest", "quarkus-extension"]
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
resource "github_team" "quarkus_micrometer_registry" {
  name                      = "quarkiverse-micrometer-registry"
  description               = "Quarkiverse team for the micrometer-registry extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_micrometer_registry" {
  team_id    = github_team.quarkus_micrometer_registry.id
  repository = github_repository.quarkus_micrometer_registry.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_micrometer_registry" {
  for_each = { for tm in ["kenfinnigan", "ebullient", "jonatan-ivanov"] : tm => tm }
  team_id  = github_team.quarkus_micrometer_registry.id
  username = each.value
  role     = "maintainer"
}
