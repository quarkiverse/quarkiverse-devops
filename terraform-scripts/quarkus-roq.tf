# Create repository
resource "github_repository" "quarkus_statiq" {
  name                   = "quarkus-roq"
  description            = "The Roq Static Site Generator allows to easily create a static website or blog using Quarkus super-powers."
  homepage_url           = "https://iamroq.dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  has_discussions        = true
  topics                 = ["quarkus-extension", "web", "static", "ssg", "site", "generator", "generate", "blog", "hacktoberfest"]
}

resource "github_repository_pages" "quarkus_statiq" {
  repository     = github_repository.quarkus_statiq.name
  cname          = "iamroq.dev"
  build_type     = "workflow"
  https_enforced = true
  public         = true
}

resource "github_repository_vulnerability_alerts" "quarkus_statiq" {
  repository = github_repository.quarkus_statiq.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_statiq" {
  name           = "quarkiverse-roq"
  description    = "roq team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_statiq" {
  team_id    = github_team.quarkus_statiq.id
  repository = github_repository.quarkus_statiq.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_statiq" {
  for_each = { for tm in ["ia3andy", "melloware", "mcruzdev", "jtama"] : tm => tm }
  team_id  = github_team.quarkus_statiq.id
  username = each.value
  role     = "maintainer"
}

# Add admin users
resource "github_repository_collaborator" "quarkus_statiq" {
  for_each   = { for tm in ["ia3andy"] : tm => tm }
  repository = github_repository.quarkus_statiq.name
  username   = each.value
  permission = "admin"
}

# Add organization secrets
resource "github_actions_organization_secret_repository" "quarkus_statiq" {
  for_each      = { for k in [local.secrets.surge_token] : k => k }
  secret_name   = each.value
  repository_id = github_repository.quarkus_statiq.repo_id
}

