# Create repository
resource "github_repository" "quarkus_elasticsearch_reactive" {
  name                   = "quarkus-elasticsearch-reactive"
  description            = "Quarkus Elastic Search Reactive extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_elasticsearch_reactive" {
  name                      = "quarkiverse-elasticsearch-reactive"
  description               = "Quarkiverse team for the elasticsearch-reactive extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_elasticsearch_reactive" {
  team_id    = github_team.quarkus_elasticsearch_reactive.id
  repository = github_repository.quarkus_elasticsearch_reactive.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_elasticsearch_reactive" {
  for_each = { for tm in ["loicmathieu"] : tm => tm }
  team_id  = github_team.quarkus_elasticsearch_reactive.id
  username = each.value
  role     = "maintainer"
}

# Create main branch
resource "github_branch" "quarkus_elasticsearch_reactive" {
  repository = github_repository.quarkus_elasticsearch_reactive.name
  branch     = "main"
}

# Set default branch
resource "github_branch_default" "quarkus_elasticsearch_reactive" {
  repository = github_repository.quarkus_elasticsearch_reactive.name
  branch     = github_branch.quarkus_elasticsearch_reactive.branch
}