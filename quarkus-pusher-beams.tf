# Create repository
resource "github_repository" "quarkus_pusher_beams" {
  name                   = "quarkus-pusher-beams"
  description            = "Pusher beams is a notification solution (saas) to send notifications to Android, iOS, Web clients (single/grouped notification, topic based notification, authenticated clients notifications)"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_pusher_beams" {
  name                      = "quarkiverse-pusher-beams"
  description               = "Quarkus Pusher Beams team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_pusher_beams" {
  team_id    = github_team.quarkus_pusher_beams.id
  repository = github_repository.quarkus_pusher_beams.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_pusher_beams" {
  for_each = { for tm in ["nicolas-vivot"] : tm => tm }
  team_id  = github_team.quarkus_pusher_beams.id
  username = each.value
  role     = "maintainer"
}
