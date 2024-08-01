# Create repository
resource "github_repository" "quarkus_openfga_client" {
  name                   = "quarkus-openfga-client"
  description            = "Quarkus extension for OpenFGA support"
  homepage_url           = "https://openfga.dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["openfga", "zanzibar", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_openfga_client" {
  name                      = "quarkiverse-openfga-client"
  description               = "Quarkiverse team for the openfga-client extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_openfga_client" {
  team_id    = github_team.quarkus_openfga_client.id
  repository = github_repository.quarkus_openfga_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_openfga_client" {
  for_each = { for tm in ["kdubb"] : tm => tm }
  team_id  = github_team.quarkus_openfga_client.id
  username = each.value
  role     = "maintainer"
}
