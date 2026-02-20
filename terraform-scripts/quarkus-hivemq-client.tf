# Create repository
resource "github_repository" "quarkus_hivemq_client" {
  name                   = "quarkus-hivemq-client"
  description            = "Quarkus HiveMQ Client extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_hivemq_client" {
  name                      = "quarkiverse-hivemq-client"
  description               = "Quarkiverse team for the hivemq_client extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_hivemq_client" {
  team_id    = github_team.quarkus_hivemq_client.id
  repository = github_repository.quarkus_hivemq_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_hivemq_client" {
  for_each = { for tm in ["masini", "pjgg", "codepitbull", "gutmox", "ayagsan"] : tm => tm }
  team_id  = github_team.quarkus_hivemq_client.id
  username = each.value
  role     = "maintainer"
}
