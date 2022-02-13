# Create repository
resource "github_repository" "quarkus_amazon_alexa" {
  name                   = "quarkus-amazon-alexa"
  description            = "Quarkus Amazon Alexa extension"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_amazon_alexa" {
  name                      = "quarkiverse-amazon-alexa"
  description               = "Quarkiverse team for the Amazon Alexa extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_amazon_alexa" {
  team_id    = github_team.quarkus_amazon_alexa.id
  repository = github_repository.quarkus_amazon_alexa.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_amazon_alexa" {
  for_each = { for tm in ["oztimpower"] : tm => tm }
  team_id  = github_team.quarkus_amazon_alexa.id
  username = each.value
  role     = "maintainer"
}
