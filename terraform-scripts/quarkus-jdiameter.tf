# Create repository
resource "github_repository" "quarkus_jdiameter" {
  name                   = "quarkus-jdiameter"
  description            = "Quarkus JDiameter extension - Diameter protocol support"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-jdiameter/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "jdiameter"]
}

# Create team
resource "github_team" "quarkus_jdiameter" {
  name                      = "quarkiverse-jdiameter"
  description               = "jdiameter team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jdiameter" {
  team_id    = github_team.quarkus_jdiameter.id
  repository = github_repository.quarkus_jdiameter.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jdiameter" {
  for_each = { for tm in ["eddiecarpenter"] : tm => tm }
  team_id  = github_team.quarkus_jdiameter.id
  username = each.value
  role     = "maintainer"
}
