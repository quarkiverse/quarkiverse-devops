# Create repository
resource "github_repository" "quarkus_jdbc_singlestore" {
  name                   = "quarkus-jdbc-singlestore"
  description            = "SingleStore is a distributed SQL database built from the ground up for maximum performance for transactions and analytics"
  homepage_url           = "https://www.singlestore.com/"
  archive_on_destroy     = true
  allow_update_branch    = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["jdbc", "singlestore", "quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_jdbc_singlestore" {
  name                      = "quarkiverse-jdbc-singlestore"
  description               = "jdbc-singlestore team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jdbc_singlestore" {
  team_id    = github_team.quarkus_jdbc_singlestore.id
  repository = github_repository.quarkus_jdbc_singlestore.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jdbc_singlestore" {
  for_each = { for tm in ["Hemantkumar-Chigadani"] : tm => tm }
  team_id  = github_team.quarkus_jdbc_singlestore.id
  username = each.value
  role     = "maintainer"
}
