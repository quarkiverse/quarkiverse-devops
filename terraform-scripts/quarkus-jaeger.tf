# Create repository
resource "github_repository" "quarkus_jaeger" {
  name                   = "quarkus-jaeger"
  description            = "An open source software for tracing transactions between distributed services"
  homepage_url           = "https://www.jaegertracing.io/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "tracing", "jaeger"]
}

# Create team
resource "github_team" "quarkus_jaeger" {
  name                      = "quarkiverse-jaeger"
  description               = "jaeger team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jaeger" {
  team_id    = github_team.quarkus_jaeger.id
  repository = github_repository.quarkus_jaeger.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jaeger" {
  for_each = { for tm in ["gsmet", "brunobat"] : tm => tm }
  team_id  = github_team.quarkus_jaeger.id
  username = each.value
  role     = "maintainer"
}
