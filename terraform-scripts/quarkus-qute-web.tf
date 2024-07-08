# Create repository
resource "github_repository" "quarkus_qute_server_pages" {
  name                   = "quarkus-qute-web"
  description            = "Automatically expose Qute templates via HTTP"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "qute"]
}

# Create team
resource "github_team" "quarkus_qute_server_pages" {
  name                      = "quarkiverse-qute-web"
  description               = "qute-web team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_qute_server_pages" {
  team_id    = github_team.quarkus_qute_server_pages.id
  repository = github_repository.quarkus_qute_server_pages.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_qute_server_pages" {
  for_each = { for tm in ["mkouba", "ia3andy"] : tm => tm }
  team_id  = github_team.quarkus_qute_server_pages.id
  username = each.value
  role     = "maintainer"
}
