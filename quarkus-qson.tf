# Create repository
resource "github_repository" "quarkus_qson" {
  name                   = "quarkus-qson"
  description            = "Quarkus Extension for the QSon JSON Parser"
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
resource "github_team" "quarkus_qson" {
  name                      = "quarkiverse-qson"
  description               = "Quarkiverse team for the Qson extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_qson" {
  team_id    = github_team.quarkus_qson.id
  repository = github_repository.quarkus_qson.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_qson" {
  for_each = { for tm in ["patriot1burke"] : tm => tm }
  team_id  = github_team.quarkus_qson.id
  username = each.value
  role     = "maintainer"
}
