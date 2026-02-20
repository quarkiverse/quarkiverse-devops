# Create repository
resource "github_repository" "quarkus_libpostal" {
  name                   = "quarkus-libpostal"
  description            = "A Quarkus extension to enable easy access to the LibPostal library for address parsing and normalization"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-libpostal/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "libpostal", "address-parsing", "normalization", "quarkiverse"]
}

# Create team
resource "github_team" "quarkus_libpostal" {
  name                      = "quarkiverse-libpostal"
  description               = "libpostal team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_libpostal" {
  team_id    = github_team.quarkus_libpostal.id
  repository = github_repository.quarkus_libpostal.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_libpostal" {
  for_each = { for tm in ["dnebing"] : tm => tm }
  team_id  = github_team.quarkus_libpostal.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_libpostal" {
  name        = "main"
  repository  = github_repository.quarkus_libpostal.name
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
