# Create repository
resource "github_repository" "quarkus_playpen" {
  name                   = "quarkus-playpen"
  description            = "Live local development on a deployed k8s service"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-playpen/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "operator", "kubernetes", "local-dev-k8s", "remote-dev-k8s"]
}

# Create team
resource "github_team" "quarkus_playpen" {
  name                      = "quarkiverse-playpen"
  description               = "playpen team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_playpen" {
  team_id    = github_team.quarkus_playpen.id
  repository = github_repository.quarkus_playpen.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_playpen" {
  for_each = { for tm in ["patriot1burke"] : tm => tm }
  team_id  = github_team.quarkus_playpen.id
  username = each.value
  role     = "maintainer"
}
