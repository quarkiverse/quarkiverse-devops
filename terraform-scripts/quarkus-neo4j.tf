# Create repository
resource "github_repository" "quarkus_neo4j" {
  name                   = "quarkus-neo4j"
  description            = "Quarkus Neo4j extension"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_neo4j" {
  name                      = "quarkiverse-neo4j"
  description               = "Quarkiverse team for the Neo4j extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_neo4j" {
  team_id    = github_team.quarkus_neo4j.id
  repository = github_repository.quarkus_neo4j.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_neo4j" {
  for_each = { for tm in ["michael-simons"] : tm => tm }
  team_id  = github_team.quarkus_neo4j.id
  username = each.value
  role     = "maintainer"
}
