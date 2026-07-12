# Create repository
resource "github_repository" "quarkus_shim" {
  name                   = "quarkus-shim"
  description            = "Patch any Java class at build time — insert, wrap, or replace behavior in code you don't own"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-shim/dev/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  topics                 = ["quarkus-extension", "bytecode", "patching", "instrumentation", "asm", "build-time"]
}

resource "github_repository_vulnerability_alerts" "quarkus_shim" {
  repository = github_repository.quarkus_shim.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_shim" {
  name           = "quarkiverse-shim"
  description    = "Shim team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_shim" {
  team_id    = github_team.quarkus_shim.id
  repository = github_repository.quarkus_shim.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_shim" {
  for_each = { for tm in ["Eng-Fouad"] : tm => tm }
  team_id  = github_team.quarkus_shim.id
  username = each.value
  role     = "maintainer"
}
