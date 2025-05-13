# Create repository
resource "github_repository" "quarkus_proxy_wasm" {
  name                   = "quarkus-proxy-wasm"
  description            = "A proxy-wasm host implementation for Quarkus"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-proxy-wasm/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "proxy-wasm", "http-filters"]
}

# Create team
resource "github_team" "quarkus_proxy_wasm" {
  name                      = "quarkiverse-proxy-wasm"
  description               = "proxy-wasm team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_proxy_wasm" {
  team_id    = github_team.quarkus_proxy_wasm.id
  repository = github_repository.quarkus_proxy_wasm.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_proxy_wasm" {
  for_each = { for tm in ["chirino", "andreaTP"] : tm => tm }
  team_id  = github_team.quarkus_proxy_wasm.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_proxy_wasm" {
  name        = "main"
  repository  = github_repository.quarkus_proxy_wasm.name
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
