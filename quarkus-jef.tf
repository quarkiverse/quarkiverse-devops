# Create repository
resource "github_repository" "quarkus_jef" {
  name                   = "quarkus-jef"
  description            = "Java Embedded Framework - provides access from java for hardware and one board computers like Raspberry Pi, Orange Pi, Banana Pi and etc. to control SPI / I2C / GPIO or Serial ports"
  archive_on_destroy     = true
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
resource "github_team" "quarkus_jef" {
  name                      = "quarkiverse-jef"
  description               = "Quarkiverse team for the jef extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_jef" {
  team_id    = github_team.quarkus_jef.id
  repository = github_repository.quarkus_jef.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_jef" {
  for_each = { for tm in ["alexeysharandin"] : tm => tm }
  team_id  = github_team.quarkus_jef.id
  username = each.value
  role     = "maintainer"
}