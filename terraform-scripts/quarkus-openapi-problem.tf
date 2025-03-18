# Create repository
resource "github_repository" "quarkus_openapi_problem" {
  name                   = "quarkus-openapi-problem"
  description            = "Standardized error responses for Quarkus REST APIs using Problem Details (RFC9457)"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-openapi-problem/dev"
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
  topics                 = ["quarkus-extension", "rfc9457", "openapi", "rest", "resteasy", "jaxrs", "json", "jackson", "jakarta-rest", "problem", "error", "exception"]
}

# Create team
resource "github_team" "quarkus_openapi_problem" {
  name                      = "quarkiverse-openapi-problem"
  description               = "openapi-problem team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_openapi_problem" {
  team_id    = github_team.quarkus_openapi_problem.id
  repository = github_repository.quarkus_openapi_problem.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_openapi_problem" {
  for_each = { for tm in ["melloware", "tmulle", "lwitkowski"] : tm => tm }
  team_id  = github_team.quarkus_openapi_problem.id
  username = each.value
  role     = "maintainer"
}
