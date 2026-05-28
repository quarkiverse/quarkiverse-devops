# Create repository
resource "github_repository" "quarkus_fory" {
  name                        = "quarkus-fory"
  description                 = "A blazingly fast multi-language serialization framework powered by JIT and zero-copy."
  homepage_url                = "https://docs.quarkiverse.io/quarkus-fory/dev"
  allow_update_branch         = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
  archive_on_destroy          = true
  delete_branch_on_merge      = true
  has_issues                  = true
  topics                      = ["quarkus-extension", "fory", "serialization"]
  merge_commit_message        = "PR_BODY"
  merge_commit_title          = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"
  squash_merge_commit_title   = "PR_TITLE"
}

resource "github_repository_vulnerability_alerts" "quarkus_fory" {
  repository = github_repository.quarkus_fory.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_fory" {
  name           = "quarkiverse-fory"
  description    = "fury team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_fory" {
  team_id    = github_team.quarkus_fory.id
  repository = github_repository.quarkus_fory.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_fory" {
  for_each = { for tm in ["chaokunyang", "zhfeng", "JiriOndrusek"] : tm => tm }
  team_id  = github_team.quarkus_fory.id
  username = each.value
  role     = "maintainer"
}
