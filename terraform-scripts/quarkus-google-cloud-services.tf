# Create repository
resource "github_repository" "quarkus_google_cloud_services" {
  name                   = "quarkus-google-cloud-services"
  description            = "Google Cloud Services Quarkus Extensions"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  has_wiki               = true
  homepage_url           = "https://docs.quarkiverse.io/quarkus-google-cloud-services/main/index.html"
  topics                 = ["gcp", "hacktoberfest", "quarkus", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_google_cloud_services" {
  name                      = "quarkiverse-google-cloud-services"
  description               = "Quarkiverse team for the Google Cloud Services extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_google_cloud_services" {
  team_id    = github_team.quarkus_google_cloud_services.id
  repository = github_repository.quarkus_google_cloud_services.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_google_cloud_services" {
  for_each = { for tm in ["loicmathieu"] : tm => tm }
  team_id  = github_team.quarkus_google_cloud_services.id
  username = each.value
  role     = "maintainer"
}

# Add outside collaborators to the repository
resource "github_repository_collaborator" "quarkus_google_cloud_services" {
  for_each   = { for tm in ["dzou"] : tm => tm }
  repository = github_repository.quarkus_google_cloud_services.name
  username   = each.value
  permission = "triage"
}
