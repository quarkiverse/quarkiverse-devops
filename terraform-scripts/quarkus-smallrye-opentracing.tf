# Create repository
resource "github_repository" "quarkus_smallrye_opentracing" {
  name                   = "quarkus-smallrye-opentracing"
  description            = "A MicroProfile-OpenTracing implementation"
  homepage_url           = "https://smallrye.io/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "smallrye", "opentracing"]
}

# Create team
resource "github_team" "quarkus_smallrye_opentracing" {
  name                      = "quarkiverse-smallrye-opentracing"
  description               = "smallrye-opentracing team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_smallrye_opentracing" {
  team_id    = github_team.quarkus_smallrye_opentracing.id
  repository = github_repository.quarkus_smallrye_opentracing.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_smallrye_opentracing" {
  for_each = { for tm in ["gsmet", "brunobat"] : tm => tm }
  team_id  = github_team.quarkus_smallrye_opentracing.id
  username = each.value
  role     = "maintainer"
}
