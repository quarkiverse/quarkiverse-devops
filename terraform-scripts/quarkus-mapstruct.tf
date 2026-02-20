# Create repository
resource "github_repository" "quarkus_mapstruct" {
  name                   = "quarkus-mapstruct"
  description            = "MapStruct is a code generator that greatly simplifies the implementation of mappings between Java bean types based on a convention over configuration approach."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-mapstruct/dev"
  allow_update_branch    = true
  allow_auto_merge       = true
  allow_merge_commit     = false
  allow_squash_merge     = false
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "mapstruct"]
}

# Create team
resource "github_team" "quarkus_mapstruct" {
  name                      = "quarkiverse-mapstruct"
  description               = "mapstruct team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mapstruct" {
  team_id    = github_team.quarkus_mapstruct.id
  repository = github_repository.quarkus_mapstruct.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_mapstruct" {
  for_each = { for tm in ["Postremus"] : tm => tm }
  team_id  = github_team.quarkus_mapstruct.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_mapstruct" {
  name        = "main"
  repository  = github_repository.quarkus_mapstruct.name
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
