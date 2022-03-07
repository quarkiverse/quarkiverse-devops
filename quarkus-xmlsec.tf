# Create repository
resource "github_repository" "quarkus_xmlsec" {
  name                   = "quarkus-xmlsec"
  description            = "Quarkus XML Security extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true

  topics = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_xmlsec" {
  name                      = "quarkiverse-xmlsec"
  description               = "Quarkiverse team for the XML Security extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_xmlsec" {
  team_id    = github_team.quarkus_xmlsec.id
  repository = github_repository.quarkus_xmlsec.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_xmlsec" {
  for_each = { for tm in ["gastaldi", "martinffx"] : tm => tm }
  team_id  = github_team.quarkus_xmlsec.id
  username = each.value
  role     = "maintainer"
}
