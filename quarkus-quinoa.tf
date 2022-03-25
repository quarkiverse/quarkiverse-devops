# Create repository
resource "github_repository" "quarkus_quinoa" {
  name                   = "quarkus-quinoa"
  description            = "Quinoa is a Quarkus extension which eases the development, the build and serving of single page apps (built with NodeJS: React, Angular, …) alongside Quarkus . It is possible to use it with a Quarkus backend in a single project."
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
}

# Create team
resource "github_team" "quarkus_quinoa" {
  name                      = "quarkiverse-quinoa"
  description               = "Quarkiverse team for the quinoa extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_quinoa" {
  team_id    = github_team.quarkus_quinoa.id
  repository = github_repository.quarkus_quinoa.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_quinoa" {
  for_each = { for tm in ["ia3andy", "phillip-kruger"] : tm => tm }
  team_id  = github_team.quarkus_quinoa.id
  username = each.value
  role     = "maintainer"
}
