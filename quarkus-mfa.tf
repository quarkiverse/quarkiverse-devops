# Create repository
resource "github_repository" "quarkus_mfa" {
  name                   = "quarkus-mfa"
  description            = "Enhanced Form Based Authentication with TOTP MFA for both HTML and JSON based authentication"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "mfa", "authentication"]
}

# Create team
resource "github_team" "quarkus_mfa" {
  name                      = "quarkiverse-mfa"
  description               = "Quarkiverse MFA team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mfa" {
  team_id    = github_team.quarkus_mfa.id
  repository = github_repository.quarkus_mfa.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mfa" {
  for_each = { for tm in ["aaronanderson"] : tm => tm }
  team_id  = github_team.quarkus_mfa.id
  username = each.value
  role     = "maintainer"
}
