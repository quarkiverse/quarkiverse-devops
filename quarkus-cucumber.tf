# Create repository
resource "github_repository" "quarkus_cucumber" {
  name                   = "quarkus-cucumber"
  description            = "Quarkus Cucumber extension"
  delete_branch_on_merge = true
  topics                 = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_cucumber" {
  name                      = "quarkiverse-cucumber"
  description               = "Quarkiverse team for the Cucumber extension"
  create_default_maintainer = false
  privacy                   = "closed"
}

# Add team to repository
resource "github_team_repository" "quarkus_cucumber" {
  team_id    = github_team.quarkus_cucumber.id
  repository = github_repository.quarkus_cucumber.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_cucumber" {
  for_each = { for tm in ["stuartwdouglas", "christophd"] : tm => tm }
  team_id  = github_team.quarkus_cucumber.id
  username = each.value
  role     = "maintainer"
}
