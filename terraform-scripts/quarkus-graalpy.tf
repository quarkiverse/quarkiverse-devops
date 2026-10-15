# Create repository
resource "github_repository" "quarkus_graalpy" {
  name                   = "quarkus-graalpy"
  description            = "Quarkus extension for GraalPy, providing embedded Python execution, first-class Python source integration, and declarative CDI bindings between Java interfaces and Python modules"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-graalpy/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "graalpy", "python", "graalvm", "polyglot", "python-embedding", "java-python", "quarkus", "native-image"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_graalpy" {
  repository = github_repository.quarkus_graalpy.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_graalpy" {
  name           = "quarkiverse-graalpy"
  description    = "graalpy team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_graalpy" {
  team_id    = github_team.quarkus_graalpy.id
  repository = github_repository.quarkus_graalpy.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_graalpy" {
  for_each = { for tm in ["igfasouza"] : tm => tm }
  team_id  = github_team.quarkus_graalpy.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_graalpy" {
  name        = "main"
  repository  = github_repository.quarkus_graalpy.name
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
