# Create repository
resource "github_repository" "quarkus_vault" {
  name                   = "quarkus-vault"
  description            = "Quarkus HashiCorp Vault extension"
  archive_on_destroy     = true
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
resource "github_team" "quarkus_vault" {
  name                      = "quarkiverse-vault"
  description               = "Quarkiverse team for the HashiCorp Vault extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_vault" {
  team_id    = github_team.quarkus_vault.id
  repository = github_repository.quarkus_vault.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_vault" {
  for_each = { for tm in ["vsevel", "sberyozkin", "kdubb"] : tm => tm }
  team_id  = github_team.quarkus_vault.id
  username = each.value
  role     = "maintainer"
}
