# Create repository
resource "github_repository" "quarkus_jgrapht" {
  name                   = "quarkus-jgrapht"
  description            = "Quarkus JGraphT extension"
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
resource "github_team" "quarkus_jgrapht" {
  name                      = "quarkiverse-jgrapht"
  description               = "Quarkiverse team for the JGrapht extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jgrapht" {
  team_id    = github_team.quarkus_jgrapht.id
  repository = github_repository.quarkus_jgrapht.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jgrapht" {
  for_each = { for tm in ["rsvoboda"] : tm => tm }
  team_id  = github_team.quarkus_jgrapht.id
  username = each.value
  role     = "maintainer"
}
