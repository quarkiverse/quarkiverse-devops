# Create repository
resource "github_repository" "quarkus_jnosql" {
  name                   = "quarkus-jnosql"
  description            = "The Quarkus JNoSql Extension adds support for JNoSQL, an implementation of Jakarta NoSQL."
  homepage_url           = "http://www.jnosql.org/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "jnosql", "nosql"]
}

# Create team
resource "github_team" "quarkus_jnosql" {
  name                      = "quarkiverse-jnosql"
  description               = "jnosql team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jnosql" {
  team_id    = github_team.quarkus_jnosql.id
  repository = github_repository.quarkus_jnosql.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jnosql" {
  for_each = { for tm in ["amoscatelli", "otaviojava", "dearrudam"] : tm => tm }
  team_id  = github_team.quarkus_jnosql.id
  username = each.value
  role     = "maintainer"
}
