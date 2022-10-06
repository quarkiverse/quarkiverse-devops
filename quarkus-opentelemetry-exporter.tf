# Create repository
resource "github_repository" "quarkus_opentelemetry_exporter" {
  name                   = "quarkus-opentelemetry-exporter"
  description            = "Quarkus extensions related with additional OpenTelemetry exporters"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_opentelemetry_exporter" {
  name                      = "quarkiverse-opentelemetry-exporter"
  description               = "opentelemetry-exporter team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_opentelemetry_exporter" {
  team_id    = github_team.quarkus_opentelemetry_exporter.id
  repository = github_repository.quarkus_opentelemetry_exporter.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_opentelemetry_exporter" {
  for_each = { for tm in ["brunobat"] : tm => tm }
  team_id  = github_team.quarkus_opentelemetry_exporter.id
  username = each.value
  role     = "maintainer"
}