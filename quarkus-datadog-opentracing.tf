# Create repository
resource "github_repository" "quarkus_datadog_opentracing" {
  name                   = "quarkus-datadog-opentracing"
  description            = "Quarkus Datadog Tracing"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_datadog_opentracing" {
  name                      = "quarkiverse-datadog-opentracing"
  description               = "Quarkiverse team for the Datadog OpenTracing extension"
  create_default_maintainer = false
  privacy                   = "closed"
}

# Add team to repository
resource "github_team_repository" "quarkus_datadog_opentracing" {
  team_id    = github_team.quarkus_datadog_opentracing.id
  repository = github_repository.quarkus_datadog_opentracing.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_datadog_opentracing" {
  for_each = { for tm in ["nicolas-vivot"] : tm => tm }
  team_id  = github_team.quarkus_datadog_opentracing.id
  username = each.value
  role     = "maintainer"
}
