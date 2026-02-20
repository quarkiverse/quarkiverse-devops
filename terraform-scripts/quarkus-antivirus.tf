# Create repository
resource "github_repository" "quarkus_antivirus" {
  name                   = "quarkus-antivirus"
  description            = "Virus scan files using ClamAV or VirusTotal"
  homepage_url           = "https://www.clamav.net/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "antivirus", "clamav", "virustotal", "security", "file"]
}

# Create team
resource "github_team" "quarkus_antivirus" {
  name                      = "quarkiverse-antivirus"
  description               = "antivirus team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_antivirus" {
  team_id    = github_team.quarkus_antivirus.id
  repository = github_repository.quarkus_antivirus.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_antivirus" {
  for_each = { for tm in ["melloware"] : tm => tm }
  team_id  = github_team.quarkus_antivirus.id
  username = each.value
  role     = "maintainer"
}
