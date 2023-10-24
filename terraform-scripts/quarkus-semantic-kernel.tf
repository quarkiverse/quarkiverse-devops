# Create repository
resource "github_repository" "quarkus_semantic_kernel" {
  name                   = "quarkus-semantic-kernel"
  description            = "This extension eases the integration of Semantic Kernel for Java with Quarkus"
  homepage_url           = "https://learn.microsoft.com/en-us/semantic-kernel/overview/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "AI", "Artificial Intelligence", "OpenAI", "Azure OpenAI", "Hugging Face"]
}

# Create team
resource "github_team" "quarkus_semantic_kernel" {
  name                      = "quarkiverse-semantic-kernel"
  description               = "semantic-kernel team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_semantic_kernel" {
  team_id    = github_team.quarkus_semantic_kernel.id
  repository = github_repository.quarkus_semantic_kernel.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_semantic_kernel" {
  for_each = { for tm in ["agoncal"] : tm => tm }
  team_id  = github_team.quarkus_semantic_kernel.id
  username = each.value
  role     = "maintainer"
}
