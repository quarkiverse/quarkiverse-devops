# Create repository
resource "github_repository" "quarkus_univocity_parsers" {
  name                   = "quarkus-univocity-parsers"
  description            = "Quarkus Univocity Parsers extension"
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
resource "github_team" "quarkus_univocity_parsers" {
  name                      = "quarkiverse-univocity-parsers"
  description               = "Quarkiverse team for the univocity-parsers extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_univocity_parsers" {
  team_id    = github_team.quarkus_univocity_parsers.id
  repository = github_repository.quarkus_univocity_parsers.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_univocity_parsers" {
  for_each = { for tm in ["aruffie"] : tm => tm }
  team_id  = github_team.quarkus_univocity_parsers.id
  username = each.value
  role     = "maintainer"
}
