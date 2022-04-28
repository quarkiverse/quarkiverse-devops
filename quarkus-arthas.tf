# Create repository
resource "github_repository" "quarkus_arthas" {
  name                   = "quarkus-arthas"
  description            = "Arthas is a Java Diagnostic tool open sourced by Alibaba. Arthas allows developers to troubleshoot production issues for Java applications without modifying code or restarting servers."
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
resource "github_team" "quarkus_arthas" {
  name                      = "quarkiverse-arthas"
  description               = "arthas team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_arthas" {
  team_id    = github_team.quarkus_arthas.id
  repository = github_repository.quarkus_arthas.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_arthas" {
  for_each = { for tm in ["geoand"] : tm => tm }
  team_id  = github_team.quarkus_arthas.id
  username = each.value
  role     = "maintainer"
}