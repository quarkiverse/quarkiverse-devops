# Create repository
resource "github_repository" "quarkus_amazon_services" {
  name                   = "quarkus-amazon-services"
  description            = "Quarkus Amazon Services extensions"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_amazon_services" {
  name                      = "quarkiverse-amazon-services"
  description               = "Quarkiverse team for the Amazon Services extensions"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_amazon_services" {
  team_id    = github_team.quarkus_amazon_services.id
  repository = github_repository.quarkus_amazon_services.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_amazon_services" {
  for_each = { for tm in ["marcinczeczko"] : tm => tm }
  team_id  = github_team.quarkus_amazon_services.id
  username = each.value
  role     = "maintainer"
}
