# Create repository
resource "github_repository" "quarkus_pooled_jms" {
  name                   = "quarkus-pooled-jms"
  description            = "Quarkus extension for a JMS Connection pool for messaging applications supporting JMS 1.1 and 2.0 clients"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "jms", "messaging"]
}

resource "github_repository_vulnerability_alerts" "quarkus_pooled_jms" {
  repository = github_repository.quarkus_pooled_jms.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_pooled_jms" {
  name           = "quarkiverse-pooled-jms"
  description    = "pooled-jms team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_pooled_jms" {
  team_id    = github_team.quarkus_pooled_jms.id
  repository = github_repository.quarkus_pooled_jms.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_pooled_jms" {
  for_each = { for tm in ["zhfeng"] : tm => tm }
  team_id  = github_team.quarkus_pooled_jms.id
  username = each.value
  role     = "maintainer"
}
