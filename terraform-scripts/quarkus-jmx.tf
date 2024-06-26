# Create repository
resource "github_repository" "quarkus_jmx" {
  name                   = "quarkus-jmx"
  description            = "Provide JMX Management Beans"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-jmx/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "jmx"]
}

# Create team
resource "github_team" "quarkus_jmx" {
  name                      = "quarkiverse-jmx"
  description               = "jmx team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jmx" {
  team_id    = github_team.quarkus_jmx.id
  repository = github_repository.quarkus_jmx.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jmx" {
  for_each = { for tm in ["d135-1r43"] : tm => tm }
  team_id  = github_team.quarkus_jmx.id
  username = each.value
  role     = "maintainer"
}
