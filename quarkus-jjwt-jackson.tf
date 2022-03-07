# Create repository
resource "github_repository" "quarkus_jjwt_jackson" {
  name                   = "quarkus-jjwt-jackson"
  description            = "Quarkus extension for Java JWT"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  #has_discussions        = true
  vulnerability_alerts = true

  topics = ["quarkus-extension"]
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
resource "github_team" "quarkus_jjwt_jackson" {
  name                      = "quarkiverse-jjwt-jackson"
  description               = "Quarkiverse team for the jjwt-jackson extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jjwt_jackson" {
  team_id    = github_team.quarkus_jjwt_jackson.id
  repository = github_repository.quarkus_jjwt_jackson.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jjwt_jackson" {
  for_each = { for tm in ["gsmet"] : tm => tm }
  team_id  = github_team.quarkus_jjwt_jackson.id
  username = each.value
  role     = "maintainer"
}
