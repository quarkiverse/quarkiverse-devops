# Create repository
resource "github_repository" "quarkus_pdfbox" {
  name                   = "quarkus-pdfbox"
  description            = "An open source Java tool for working with PDF documents"
  homepage_url           = "https://https://pdfbox.apache.org/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "pdf", "pdfbox", "apache"]
}

# Create team
resource "github_team" "quarkus_pdfbox" {
  name                      = "quarkiverse-pdfbox"
  description               = "pdfbox team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_pdfbox" {
  team_id    = github_team.quarkus_pdfbox.id
  repository = github_repository.quarkus_pdfbox.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_pdfbox" {
  for_each = { for tm in ["gastaldi"] : tm => tm }
  team_id  = github_team.quarkus_pdfbox.id
  username = each.value
  role     = "maintainer"
}
