# Create repository
resource "github_repository" "quarkus_langchain4j" {
  name                   = "quarkus-langchain4j"
  description            = "Quarkus Langchain4j extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "llm", "ai", "langchain4j"]
}

# Create team
resource "github_team" "quarkus_langchain4j" {
  name                      = "quarkiverse-langchain4j"
  description               = "langchain4j team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_langchain4j" {
  team_id    = github_team.quarkus_langchain4j.id
  repository = github_repository.quarkus_langchain4j.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_langchain4j" {
  for_each = { for tm in ["geoand", "cescoffier", "maxandersen"] : tm => tm }
  team_id  = github_team.quarkus_langchain4j.id
  username = each.value
  role     = "maintainer"
}
