# Create repository
resource "github_repository" "quarkus_langfuse" {
  name                   = "quarkus-langfuse"
  description            = "Langfuse helps you ship AI Agents/Products from prototype to production and beyond."
  homepage_url           = "https://docs.quarkiverse.io/quarkus-langfuse/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_discussions        = true
  allow_merge_commit     = false
  allow_rebase_merge     = false
  allow_auto_merge       = true
  topics                 = ["quarkus-extension", "quarkus", "langfuse", "ai", "java", "evaluation", "agents", "observability"]
}

resource "github_repository_vulnerability_alerts" "quarkus_langfuse" {
  repository = github_repository.quarkus_langfuse.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_langfuse" {
  name           = "quarkiverse-langfuse"
  description    = "langfuse team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_langfuse" {
  team_id    = github_team.quarkus_langfuse.id
  repository = github_repository.quarkus_langfuse.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_langfuse" {
  for_each = { for tm in ["edeandrea", "patriot1burke"] : tm => tm }
  team_id  = github_team.quarkus_langfuse.id
  username = each.value
  role     = "maintainer"
}

variable "langfuse_os_jvm_combos" {
  type = list(object({
    os           = string
    java_version = number
  }))
  default = [
    { os = "ubuntu-latest", java_version = 17 },
    { os = "ubuntu-latest", java_version = 21 },
    { os = "ubuntu-latest", java_version = 25 }
  ]
}

variable "langfuse_os_jvm_native_combos" {
  type = list(object({
    os           = string
    java_version = number
  }))
  default = [
    { os = "ubuntu-latest", java_version = 25 }
  ]
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_langfuse" {
  name        = "main"
  repository  = github_repository.quarkus_langfuse.name
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
        for_each = var.langfuse_os_jvm_combos
        content {
          context = "Build on ${required_check.value.os} - ${required_check.value.java_version}"
        }
      }

      dynamic "required_check" {
        for_each = var.langfuse_os_jvm_native_combos
        content {
          context = "Build native on ${required_check.value.os} - ${required_check.value.java_version}"
        }
      }
    }
  }
}
