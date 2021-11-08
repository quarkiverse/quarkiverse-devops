# Create repository
resource "github_repository" "quarkus_morphia" {
  name                   = "quarkus-morphia"
  description            = "Quarkus Morphia Extension (MongoDB object-document mapper in Java based on mongodb/mongo-java-driver)"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_morphia" {
  name                      = "quarkiverse-morphia"
  description               = "Quarkiverse team for the Morphia extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_morphia" {
  team_id    = github_team.quarkus_morphia.id
  repository = github_repository.quarkus_morphia.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_morphia" {
  for_each = { for tm in ["evanchooly"] : tm => tm }
  team_id  = github_team.quarkus_morphia.id
  username = each.value
  role     = "maintainer"
}
