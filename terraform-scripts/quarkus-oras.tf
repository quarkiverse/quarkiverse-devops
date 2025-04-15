# Create repository
resource "github_repository" "quarkus_oras" {
  name                   = "quarkus-oras"
  description            = "Quarkus Extension for ORAS Java SDK"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-oras/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "oras", "oci"]
}

# Create team
resource "github_team" "quarkus_oras" {
  name                      = "quarkiverse-oras"
  description               = "oras team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_oras" {
  team_id    = github_team.quarkus_oras.id
  repository = github_repository.quarkus_oras.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_oras" {
  for_each = { for tm in ["jonesbusy"] : tm => tm }
  team_id  = github_team.quarkus_oras.id
  username = each.value
  role     = "maintainer"
}

# Create main branch
resource "github_branch" "main" {
  repository = github_repository.quarkus_oras.name
  branch     = "main"
}

# Set main as default branch
resource "github_branch_default" "main" {
  repository = github_repository.quarkus_oras.name
  branch     = github_branch.main.branch
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_oras" {
  name        = "main"
  repository  = github_repository.quarkus_oras.name
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
