# Create repository
resource "github_repository" "quarkus_bon_jova_rockstar" {
  name                   = "quarkus-bon-jova-rockstar"
  description            = "An implementation of Rockstar as a JVM language"
  homepage_url           = "https://codewithrockstar.com/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_bon_jova_rockstar" {
  name                      = "quarkiverse-bon-jova-rockstar"
  description               = "bon-jova-rockstar team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_bon_jova_rockstar" {
  team_id    = github_team.quarkus_bon_jova_rockstar.id
  repository = github_repository.quarkus_bon_jova_rockstar.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_bon_jova_rockstar" {
  for_each = { for tm in ["holly-cummins", "hannotify"] : tm => tm }
  team_id  = github_team.quarkus_bon_jova_rockstar.id
  username = each.value
  role     = "maintainer"
}
