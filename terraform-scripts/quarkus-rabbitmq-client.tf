# Create repository
resource "github_repository" "quarkus_rabbitmq_client" {
  name                   = "quarkus-rabbitmq-client"
  description            = "Quarkus extension supporting RabbitMQ"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_rabbitmq_client" {
  name                      = "quarkiverse-rabbitmq-client"
  description               = "Quarkiverse team for the rabbitmq-client extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_rabbitmq_client" {
  team_id    = github_team.quarkus_rabbitmq_client.id
  repository = github_repository.quarkus_rabbitmq_client.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_rabbitmq_client" {
  for_each = { for tm in ["bpasson", "bwijsmuller"] : tm => tm }
  team_id  = github_team.quarkus_rabbitmq_client.id
  username = each.value
  role     = "maintainer"
}
