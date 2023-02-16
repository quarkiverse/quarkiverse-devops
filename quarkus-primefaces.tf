# Create repository
resource "github_repository" "quarkus_primefaces" {
  name                   = "quarkus-primefaces"
  description            = "PrimeFaces is a popular open source framework for JavaServer Faces"
  homepage_url           = "https://primefaces.org"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "primefaces", "jsf"]
}

# Create team
resource "github_team" "quarkus_primefaces" {
  name                      = "quarkiverse-primefaces"
  description               = "primefaces team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_primefaces" {
  team_id    = github_team.quarkus_primefaces.id
  repository = github_repository.quarkus_primefaces.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_primefaces" {
  for_each = { for tm in ["melloware"] : tm => tm }
  team_id  = github_team.quarkus_primefaces.id
  username = each.value
  role     = "maintainer"
}
