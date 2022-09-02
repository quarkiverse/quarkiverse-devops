# Create repository
resource "github_repository" "quarkus_jgit" {
  name                   = "quarkus-jgit"
  description            = "Quarkus JGit extension"
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
resource "github_team" "quarkus_jgit" {
  name                      = "quarkiverse-jgit"
  description               = "Quarkiverse team for the JGit extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jgit" {
  team_id    = github_team.quarkus_jgit.id
  repository = github_repository.quarkus_jgit.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jgit" {
  for_each = { for tm in ["gastaldi"] : tm => tm }
  team_id  = github_team.quarkus_jgit.id
  username = each.value
  role     = "maintainer"
}

# Create main branch
resource "github_branch" "quarkus_jgit" {
  repository = github_repository.quarkus_jgit.name
  branch     = "main"
}

# Set main branch as default
resource "github_branch_default" "quarkus_jgit" {
  repository = github_repository.quarkus_jgit.name
  branch     = github_branch.quarkus_jgit.branch
}

# Protect main branch
resource "github_branch_protection" "quarkus_jgit" {
  repository_id = github_repository.quarkus_jgit.id
  pattern       = "main"
  required_status_checks {
    contexts = ["build"]
  }
}