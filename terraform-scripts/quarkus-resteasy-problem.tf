# Create repository
resource "github_repository" "quarkus_resteasy_problem" {
  name                   = "quarkus-resteasy-problem"
  description            = "Unified error responses for Quarkus REST APIs via Problem Details for HTTP APIs (RFC9457 & RFC7807)"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-resteasy-problem/dev"
  allow_update_branch    = true
  allow_merge_commit     = true
  allow_rebase_merge     = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_discussions        = true
  has_downloads          = true
  has_wiki               = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "rest-problem", "resteasy", "exception-handling", "rfc7807", "rfc9457"]
}

# Create team
resource "github_team" "quarkus_resteasy_problem" {
  name                      = "quarkiverse-resteasy-problem"
  description               = "resteasy-problem team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_resteasy_problem" {
  team_id    = github_team.quarkus_resteasy_problem.id
  repository = github_repository.quarkus_resteasy_problem.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_resteasy_problem" {
  for_each = { for tm in ["lwitkowski", "pazkooda"] : tm => tm }
  team_id  = github_team.quarkus_resteasy_problem.id
  username = each.value
  role     = "maintainer"
}
