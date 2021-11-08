# Create repository
resource "github_repository" "quarkus_jberet" {
  name                   = "quarkus-jberet"
  description            = "Quarkus Extension for Batch Applications."
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["java", "batch", "jsr-352", "quarkus-extension", "jberet"]
}

# Create team
resource "github_team" "quarkus_jberet" {
  name                      = "quarkiverse-jberet"
  description               = "Quarkiverse team for the jberet extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jberet" {
  team_id    = github_team.quarkus_jberet.id
  repository = github_repository.quarkus_jberet.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jberet" {
  for_each = { for tm in ["radcortez"] : tm => tm }
  team_id  = github_team.quarkus_jberet.id
  username = each.value
  role     = "maintainer"
}

# Add outside collaborators to the repository
resource "github_repository_collaborator" "quarkus_jberet" {
  for_each   = { for tm in ["aureamunoz"] : tm => tm }
  repository = github_repository.quarkus_jberet.name
  username   = each.value
  permission = "push"
}