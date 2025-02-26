# Create repository
resource "github_repository" "quarkus_tekton" {
  name                   = "quarkus-tekton"
  description            = "A Tekton extension for Quarkus"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-tekton/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "tekton"]
}

# Create team
resource "github_team" "quarkus_tekton" {
  name                      = "quarkiverse-tekton"
  description               = "Quarkiverse team for the tekton extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_tekton" {
  team_id    = github_team.quarkus_tekton.id
  repository = github_repository.quarkus_tekton.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_tekton" {
  for_each = { for tm in ["iocanel", "aureamunoz", "cmoulliard"] : tm => tm }
  team_id  = github_team.quarkus_tekton.id
  username = each.value
  role     = "maintainer"
}
