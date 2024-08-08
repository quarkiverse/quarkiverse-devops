# Create repository
resource "github_repository" "quarkus_backstage" {
  name                   = "quarkus-backstage"
  description            = "A backstage extension for Quarkus"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-backstage/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_backstage" {
  name                      = "quarkiverse-backstage"
  description               = "backstage team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_backstage" {
  team_id    = github_team.quarkus_backstage.id
  repository = github_repository.quarkus_backstage.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_backstage" {
  for_each = { for tm in ["iocanel", "aureamunoz", "cmoulliard"] : tm => tm }
  team_id  = github_team.quarkus_backstage.id
  username = each.value
  role     = "maintainer"
}
