# Create repository
resource "github_repository" "quarkus_sshd" {
  name                   = "quarkus-sshd"
  description            = "Provide basic support of Apache Mina SSHD in Quarkus."
  homepage_url           = "https://mina.apache.org/sshd-project/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "apache-sshd", "apache-mina-sshd"]
}

# Create team
resource "github_team" "quarkus_sshd" {
  name                      = "quarkiverse-sshd"
  description               = "sshd team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_sshd" {
  team_id    = github_team.quarkus_sshd.id
  repository = github_repository.quarkus_sshd.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_sshd" {
  for_each = { for tm in ["sunix"] : tm => tm }
  team_id  = github_team.quarkus_sshd.id
  username = each.value
  role     = "maintainer"
}
