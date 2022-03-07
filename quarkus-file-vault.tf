# Create repository
resource "github_repository" "quarkus_file_vault" {
  name                   = "quarkus-file-vault"
  description            = "Credentials Provider which extracts secrets from Java KeyStore"
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
resource "github_team" "quarkus_file_vault" {
  name                      = "quarkiverse-file-vault"
  description               = "Quarkiverse file-vault team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_file_vault" {
  team_id    = github_team.quarkus_file_vault.id
  repository = github_repository.quarkus_file_vault.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_file_vault" {
  for_each = { for tm in ["sberyozkin", "cescoffier", "stuartwdouglas"] : tm => tm }
  team_id  = github_team.quarkus_file_vault.id
  username = each.value
  role     = "maintainer"
}
