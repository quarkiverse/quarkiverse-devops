# Create repository
resource "github_repository" "quarkus_jberet" {
  name = "quarkus-jberet"
  description = "Quarkus Extension for Batch Applications."
  delete_branch_on_merge = true
  topics = [ "java", "batch", "jsr-352", "quarkus-extension", "jberet" ]
}

# Create team
resource "github_team" "quarkus_jberet" {
  name                      = "quarkiverse-jberet"
  description               = "Quarkiverse team for the JBeret extension"
  create_default_maintainer = true
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
  role = "maintainer"
}