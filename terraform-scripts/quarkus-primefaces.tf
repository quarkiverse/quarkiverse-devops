# Create repository
resource "github_repository" "quarkus_primefaces" {
  name                   = "quarkus-primefaces"
  description            = "Quarkus PrimeFaces Faces (JSF) Extension"
  homepage_url           = "https://github.com/primefaces/primefaces"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "primefaces", "jsf", "faces", "myfaces", "web", "primefaces-extensions"]
}

# Create team
resource "github_team" "quarkus_primefaces" {
  name                      = "quarkiverse-primefaces"
  description               = "primefaces team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_primefaces" {
  team_id    = github_team.quarkus_primefaces.id
  repository = github_repository.quarkus_primefaces.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_primefaces" {
  for_each = { for tm in ["melloware", "tandraschko", "jepsar"] : tm => tm }
  team_id  = github_team.quarkus_primefaces.id
  username = each.value
  role     = "maintainer"
}
