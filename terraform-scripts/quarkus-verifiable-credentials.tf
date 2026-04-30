# Create repository
resource "github_repository" "quarkus_verifiable_credentials" {
  name                   = "quarkus-verifiable-credentials"
  description            = "Facilitates verification of Verifiable Presentations"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-verifiable-credentials/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = ["quarkus-extension", "holder-issuer-verifier", "verifiable-credentials", "verifiable-presentations", "selective-disclosures", "sd-jwt", "zero-knowledge-proofs"]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_verifiable_credentials" {
  repository = github_repository.quarkus_verifiable_credentials.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_verifiable_credentials" {
  name           = "quarkiverse-verifiable-credentials"
  description    = "verifiable-credentials team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_verifiable_credentials" {
  team_id    = github_team.quarkus_verifiable_credentials.id
  repository = github_repository.quarkus_verifiable_credentials.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_verifiable_credentials" {
  for_each = { for tm in ["sberyozkin"] : tm => tm }
  team_id  = github_team.quarkus_verifiable_credentials.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_verifiable_credentials" {
  name        = "main"
  repository  = github_repository.quarkus_verifiable_credentials.name
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
