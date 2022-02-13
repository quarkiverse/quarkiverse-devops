# Create repository
resource "github_repository" "quarkus_renarde" {
  name                   = "quarkus-renarde"
  description            = "Server-side Web Framework with Qute templating, magic/easier controllers, auth, reverse-routing"
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
resource "github_team" "quarkus_renarde" {
  name                      = "quarkiverse-renarde"
  description               = "Quarkiverse renarde team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_renarde" {
  team_id    = github_team.quarkus_renarde.id
  repository = github_repository.quarkus_renarde.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_renarde" {
  for_each = { for tm in ["FroMage"] : tm => tm }
  team_id  = github_team.quarkus_renarde.id
  username = each.value
  role     = "maintainer"
}
