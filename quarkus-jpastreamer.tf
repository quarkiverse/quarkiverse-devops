# Create repository
resource "github_repository" "quarkus_jpastreamer" {
  name                   = "quarkus-jpastreamer"
  description            = "Express Hibernate/JPA Queries as Java Streams"
  homepage_url           = "https://www.jpastreamer.org/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "jpa", "hibernate", "stream", "java-stream", "db", "database", "data", "jpa-streamer", "jpastreamer", "spring", "jax-rs", "query", "queries"]
}

# Create team
resource "github_team" "quarkus_jpastreamer" {
  name                      = "quarkiverse-jpastreamer"
  description               = "jpastreamer team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jpastreamer" {
  team_id    = github_team.quarkus_jpastreamer.id
  repository = github_repository.quarkus_jpastreamer.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jpastreamer" {
  for_each = { for tm in ["julgus", "minborg", "dreifeldt"] : tm => tm }
  team_id  = github_team.quarkus_jpastreamer.id
  username = each.value
  role     = "maintainer"
}
