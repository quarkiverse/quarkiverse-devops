# Create repository
resource "github_repository" "quarkus_registry_protobuf" {
  name                   = "quarkus-registry-protobuf"
  description            = "Quarkus extension for supporting Protobuf serde in API registries"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-registry-protobuf/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "schema-registry", "protobuf", "kafka", "apicurio", "confluent"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_registry_protobuf" {
  repository = github_repository.quarkus_registry_protobuf.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_registry_protobuf" {
  name           = "quarkiverse-registry-protobuf"
  description    = "registry-protobuf team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_registry_protobuf" {
  team_id    = github_team.quarkus_registry_protobuf.id
  repository = github_repository.quarkus_registry_protobuf.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_registry_protobuf" {
  for_each = { for tm in ["carlesarnal"] : tm => tm }
  team_id  = github_team.quarkus_registry_protobuf.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_registry_protobuf" {
  name        = "main"
  repository  = github_repository.quarkus_registry_protobuf.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = data.github_app.quarkiverse_ci.id
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  rules {
    # Prevent force push
    non_fast_forward = true
    # Require pull request reviews before merging
    pull_request {

    }
  }
}