# Create repository
resource "github_repository" "quarkus_kubevirt" {
  name                   = "quarkus-kubevirt"
  description            = "A client and CLI for KubeVirt"
  homepage_url           = "https://kubevirt.io/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "kubevirt", "kubernetes"]
}

# Create team
resource "github_team" "quarkus_kubevirt" {
  name                      = "quarkiverse-kubevirt"
  description               = "kubevirt team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_kubevirt" {
  team_id    = github_team.quarkus_kubevirt.id
  repository = github_repository.quarkus_kubevirt.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_kubevirt" {
  for_each = { for tm in ["iocanel"] : tm => tm }
  team_id  = github_team.quarkus_kubevirt.id
  username = each.value
  role     = "maintainer"
}
