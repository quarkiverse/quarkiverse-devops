# Create repository
resource "github_repository" "quarkus_moneta" {
  name                   = "quarkus-moneta"
  description            = "Quarkus JSR 354 Java Money Extension"
  homepage_url           = "https://javamoney.github.io/ri.html"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "javamoney", "jsr354", "currency"]
}

# Create team
resource "github_team" "quarkus_moneta" {
  name                      = "quarkiverse-moneta"
  description               = "moneta team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_moneta" {
  team_id    = github_team.quarkus_moneta.id
  repository = github_repository.quarkus_moneta.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_moneta" {
  for_each = { for tm in ["andlinger", "holzleitner"] : tm => tm }
  team_id  = github_team.quarkus_moneta.id
  username = each.value
  role     = "maintainer"
}
