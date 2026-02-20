# Create repository
resource "github_repository" "quarkus_dapr" {
  name                   = "quarkus-dapr"
  description            = "The Distributed Application Runtime (Dapr) provides APIs that simplify microservice connectivity"
  homepage_url           = "https://dapr.io/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "hacktoberfest"]
}

# Create team
resource "github_team" "quarkus_dapr" {
  name                      = "quarkiverse-dapr"
  description               = "dapr team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_dapr" {
  team_id    = github_team.quarkus_dapr.id
  repository = github_repository.quarkus_dapr.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_dapr" {
  for_each = { for tm in ["mcruzdev", "naah69", "skyao", "zhfeng", "salaboy"] : tm => tm }
  team_id  = github_team.quarkus_dapr.id
  username = each.value
  role     = "maintainer"
}
