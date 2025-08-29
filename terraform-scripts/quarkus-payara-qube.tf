# Create repository
resource "github_repository" "quarkus_payara_qube" {
  name                   = "quarkus-payara-qube"
  description            = "Deploy to Payara Qube"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-payara-qube/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "deployment", "payara", "payara-qube"]
}

# Create team
resource "github_team" "quarkus_payara_qube" {
  name                      = "quarkiverse-payara-qube"
  description               = "payara-qube team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_payara_qube" {
  team_id    = github_team.quarkus_payara_qube.id
  repository = github_repository.quarkus_payara_qube.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_payara_qube" {
  for_each = { for tm in ["pdudits", "raushan606"] : tm => tm }
  team_id  = github_team.quarkus_payara_qube.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_payara_qube" {
  name        = "main"
  repository  = github_repository.quarkus_payara_qube.name
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
