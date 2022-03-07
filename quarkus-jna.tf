# Create repository
resource "github_repository" "quarkus_jna" {
  name                   = "quarkus-jna"
  description            = "Java Native Access (JNA) Quarkus Extension - https://github.com/java-native-access/jna"
  archive_on_destroy     = true
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
resource "github_team" "quarkus_jna" {
  name                      = "quarkiverse-jna"
  description               = "Quarkiverse team for the jna extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jna" {
  team_id    = github_team.quarkus_jna.id
  repository = github_repository.quarkus_jna.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jna" {
  for_each = { for tm in ["dufoli"] : tm => tm }
  team_id  = github_team.quarkus_jna.id
  username = each.value
  role     = "maintainer"
}
