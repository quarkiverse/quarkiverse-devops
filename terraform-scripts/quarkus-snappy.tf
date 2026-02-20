# Create repository
resource "github_repository" "quarkus_snappy" {
  name                   = "quarkus-snappy"
  description            = "Snappy compressor in native environment"
  homepage_url           = "https://github.com/google/snappy"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "snappy-native", "compression"]
}

# Create team
resource "github_team" "quarkus_snappy" {
  name                      = "quarkiverse-snappy"
  description               = "snappy team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_snappy" {
  team_id    = github_team.quarkus_snappy.id
  repository = github_repository.quarkus_snappy.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_snappy" {
  for_each = { for tm in ["MarcAnB"] : tm => tm }
  team_id  = github_team.quarkus_snappy.id
  username = each.value
  role     = "maintainer"
}
