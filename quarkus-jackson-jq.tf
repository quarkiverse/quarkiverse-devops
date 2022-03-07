# Create repository
resource "github_repository" "quarkus_jackson_jq" {
  name                   = "quarkus-jackson-jq"
  description            = "Quarkus extension for the Jackson JQ library"
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
resource "github_team" "quarkus_jackson_jq" {
  name                      = "quarkiverse-jackson-jq"
  description               = "Quarkiverse team for the Jackson JQ extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jackson_jq" {
  team_id    = github_team.quarkus_jackson_jq.id
  repository = github_repository.quarkus_jackson_jq.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jackson_jq" {
  for_each = { for tm in ["ricardozanini", "aloubyansky", "evacchi"] : tm => tm }
  team_id  = github_team.quarkus_jackson_jq.id
  username = each.value
  role     = "maintainer"
}
