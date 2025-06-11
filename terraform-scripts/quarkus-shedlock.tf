# Create repository
resource "github_repository" "quarkus_shedlock" {
  name                   = "quarkus-shedlock"
  description            = "Distributed lock for your scheduled tasks in Quarkus"
  homepage_url           = "https://github.com/lukas-krecan/ShedLock"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "shedlock"]
}

# Create team
resource "github_team" "quarkus_shedlock" {
  name                      = "quarkiverse-shedlock"
  description               = "shedlock team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_shedlock" {
  team_id    = github_team.quarkus_shedlock.id
  repository = github_repository.quarkus_shedlock.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_shedlock" {
  for_each = { for tm in ["dcdh", "melloware"] : tm => tm }
  team_id  = github_team.quarkus_shedlock.id
  username = each.value
  role     = "maintainer"
}
