# Create repository
resource "github_repository" "quarkus_itext" {
  name                   = "quarkus-itext"
  description            = "Create and manipulate PDFs on the fly with iText/OpenPDF"
  homepage_url           = "https://github.com/LibrePDF/OpenPDF"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "itext", "pdf", "reader", "writer", "openpdf"]
}

# Create team
resource "github_team" "quarkus_itext" {
  name                      = "quarkiverse-itext"
  description               = "itext team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_itext" {
  team_id    = github_team.quarkus_itext.id
  repository = github_repository.quarkus_itext.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_itext" {
  for_each = { for tm in ["melloware"] : tm => tm }
  team_id  = github_team.quarkus_itext.id
  username = each.value
  role     = "maintainer"
}
