# Create repository
resource "github_repository" "quarkus_mybatis" {
  name                   = "quarkus-mybatis"
  description            = "Quarkus MyBatis Extension"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  #has_discussions        = true
  vulnerability_alerts = true

  topics = ["quarkus-extension"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_mybatis" {
  name                      = "quarkiverse-mybatis"
  description               = "Quarkiverse team for the mybatis extension"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mybatis" {
  team_id    = github_team.quarkus_mybatis.id
  repository = github_repository.quarkus_mybatis.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mybatis" {
  for_each = { for tm in ["zhfeng"] : tm => tm }
  team_id  = github_team.quarkus_mybatis.id
  username = each.value
  role     = "maintainer"
}
