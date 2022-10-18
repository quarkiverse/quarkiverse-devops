# Create repository
resource "github_repository" "quarkus_pact" {
  name                   = "quarkus-pact"
  description            = "Pact is a widely-recommended framework for consumer-driven contract testing."
  homepage_url           = "https://pact.io/"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "pact", "consumer-driven-contract-testing"]
}

# Create team
resource "github_team" "quarkus_pact" {
  name                      = "quarkiverse-pact"
  description               = "Quarkiverse Pact team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_pact" {
  team_id    = github_team.quarkus_pact.id
  repository = github_repository.quarkus_pact.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_pact" {
  for_each = { for tm in ["holly-cummins"] : tm => tm }
  team_id  = github_team.quarkus_pact.id
  username = each.value
  role     = "maintainer"
}
