# Create repository
resource "github_repository" "quarkus_mateu" {
  name                   = "quarkus-mateu"
  description            = "Model-driven UIs: declare a screen as an annotated Java class and Mateu renders forms, CRUDs, wizards and app shells"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-mateu/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "ui", "model-driven", "low-code", "crud", "backoffice"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_mateu" {
  repository = github_repository.quarkus_mateu.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_mateu" {
  name           = "quarkiverse-mateu"
  description    = "mateu team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_mateu" {
  team_id    = github_team.quarkus_mateu.id
  repository = github_repository.quarkus_mateu.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_mateu" {
  for_each = { for tm in ["miguelperezcolom"] : tm => tm }
  team_id  = github_team.quarkus_mateu.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_mateu" {
  name        = "main"
  repository  = github_repository.quarkus_mateu.name
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
