# Create repository
resource "github_repository" "quarkus_easy_retrofit" {
  name                   = "quarkus-easy-retrofit"
  description            = "easy-retrofit-client provides an annotation based configuration to create Retrofit instances, and enhances general functionality through more annotations."
  homepage_url           = "https://github.com/liuziyuan/easy-retrofit"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "http-client", "retrofit"]
}

# Create team
resource "github_team" "quarkus_easy_retrofit" {
  name                      = "quarkiverse-easy-retrofit"
  description               = "easy-retrofit team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_easy_retrofit" {
  team_id    = github_team.quarkus_easy_retrofit.id
  repository = github_repository.quarkus_easy_retrofit.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_easy_retrofit" {
  for_each = { for tm in ["liuziyuan"] : tm => tm }
  team_id  = github_team.quarkus_easy_retrofit.id
  username = each.value
  role     = "maintainer"
}
