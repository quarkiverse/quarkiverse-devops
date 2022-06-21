# Create repository
resource "github_repository" "quarkus_pooled_jms" {
  name                   = "quarkus-pooled-jms"
  description            = "Quarkus extension for a JMS Connection pool for messaging applications supporting JMS 1.1 and 2.0 clients"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "jms", "messaging"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_pooled_jms" {
  name                      = "quarkiverse-pooled-jms"
  description               = "pooled-jms team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
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

# Enable apps in repository
resource "github_app_installation_repository" "quarkus_pooled_jms" {
  for_each = { for app in [local.applications.lgtm] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_pooled_jms.name
}
