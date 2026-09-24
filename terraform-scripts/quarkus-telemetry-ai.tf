# Create repository
resource "github_repository" "quarkus_telemetry_ai" {
  name                   = "quarkus-telemetry-ai"
  description            = "LLM-powered root-cause analysis of distributed telemetry data using Quarkus, LangChain4j, and Grafana LGTM via MCP"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["telemetry", "ai", "quarkus-app"]
}

resource "github_repository_vulnerability_alerts" "quarkus_telemetry_ai" {
  repository = github_repository.quarkus_telemetry_ai.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_telemetry_ai" {
  name           = "quarkiverse-telemetry-ai"
  description    = "telemetry-ai team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_telemetry_ai" {
  team_id    = github_team.quarkus_telemetry_ai.id
  repository = github_repository.quarkus_telemetry_ai.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_telemetry_ai" {
  for_each = { for tm in ["alesj"] : tm => tm }
  team_id  = github_team.quarkus_telemetry_ai.id
  username = each.value
  role     = "maintainer"
}
