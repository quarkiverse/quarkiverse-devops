# Create repository
resource "github_repository" "quarkus_fury" {
  name                        = "quarkus-fury"
  description                 = "A blazingly fast multi-language serialization framework powered by JIT and zero-copy."
  homepage_url                = "https://docs.quarkiverse.io/quarkus-fury/dev"
  allow_update_branch         = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
  archive_on_destroy          = true
  delete_branch_on_merge      = true
  has_issues                  = true
  vulnerability_alerts        = true
  topics                      = ["quarkus-extension", "fury", "serialization"]
  merge_commit_message        = "PR_BODY"
  merge_commit_title          = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"
  squash_merge_commit_title   = "PR_TITLE"
}

# Create team
resource "github_team" "quarkus_fury" {
  name                      = "quarkiverse-fury"
  description               = "fury team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_fury" {
  team_id    = github_team.quarkus_fury.id
  repository = github_repository.quarkus_fury.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_fury" {
  for_each = { for tm in ["chaokunyang", "zhfeng"] : tm => tm }
  team_id  = github_team.quarkus_fury.id
  username = each.value
  role     = "maintainer"
}
