# Create repository
resource "github_repository" "quarkus_zeebe" {
  name                   = "quarkus-zeebe"
  description            = "Camunda Zeebe Quarkus extension"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true

  topics = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_zeebe" {
  name                      = "quarkiverse-zeebe"
  description               = "Quarkiverse team for the Camunda Zeebe Quarkus extension"
  create_default_maintainer = false
  privacy                   = "closed"
}

# Add team to repository
resource "github_team_repository" "quarkus_zeebe" {
  team_id    = github_team.quarkus_zeebe.id
  repository = github_repository.quarkus_zeebe.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_zeebe" {
  for_each = { for tm in ["andrejpetras"] : tm => tm }
  team_id  = github_team.quarkus_zeebe.id
  username = each.value
  role     = "maintainer"
}
