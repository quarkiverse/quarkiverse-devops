# Create repository
resource "github_repository" "quarkus_docling" {
  name                   = "quarkus-docling"
  description            = "Docling simplifies document processing, parsing diverse formats — including advanced PDF understanding — and providing seamless integrations with the gen AI ecosystem"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-docling/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  allow_merge_commit     = false
  allow_rebase_merge     = false
  allow_auto_merge       = true
  topics                 = ["quarkus-extension", "quarkus", "docling", "ai", "document-processing", "rag", "embedding"]
}

# Create team
resource "github_team" "quarkus_docling" {
  name                      = "quarkiverse-docling"
  description               = "docling team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_docling" {
  team_id    = github_team.quarkus_docling.id
  repository = github_repository.quarkus_docling.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_docling" {
  for_each = { for tm in ["edeandrea", "lordofthejars"] : tm => tm }
  team_id  = github_team.quarkus_docling.id
  username = each.value
  role     = "maintainer"
}

variable "os_jvm_combos" {
  type = list(object({
    os           = string
    java_version = number
  }))
  default = [
    { os = "ubuntu-latest", java_version = 17 },
    { os = "ubuntu-latest", java_version = 21 }
  ]
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_docling" {
  name        = "main"
  repository  = github_repository.quarkus_docling.name
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

  bypass_actors {
    actor_type  = "RepositoryRole"
    actor_id    = 2
    bypass_mode = "always"
  }

  rules {
    # Require pull request reviews before merging
    pull_request {
      dismiss_stale_reviews_on_push = true
    }

    required_status_checks {
      strict_required_status_checks_policy = true

      dynamic "required_check" {
        for_each = var.os_jvm_combos
        content {
          context = "Build on ${required_check.value.os} - ${required_check.value.java_version}"
        }
      }
    }
  }
}
