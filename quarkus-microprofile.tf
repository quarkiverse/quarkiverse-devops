# Create repository
resource "github_repository" "quarkus_microprofile" {
  name                   = "quarkus-microprofile"
  description            = "Quarkus Microprofile extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_microprofile" {
  name                      = "quarkiverse-microprofile"
  description               = "Quarkiverse team for the microprofile extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_microprofile" {
  team_id    = github_team.quarkus_microprofile.id
  repository = github_repository.quarkus_microprofile.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_microprofile" {
  for_each = { for tm in ["radcortez"] : tm => tm }
  team_id  = github_team.quarkus_microprofile.id
  username = each.value
  role     = "maintainer"
}
