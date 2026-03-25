# Create repository
resource "github_repository" "quarkus_solr" {
  name                   = "quarkus-solr"
  description            = "Apache Solr is the blazing-fast, open source, multi-modal search platform built on the full-text, vector, and geospatial search capabilities of Apache Lucene. This extension provides integration with Solr, allowing you to easily add search capabilities to your Quarkus applications."
  visibility             = "public"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-solr/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "solr", "search"]
}

# Create team
resource "github_team" "quarkus_solr" {
  name           = "quarkiverse-solr"
  description    = "solr team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_solr" {
  team_id    = github_team.quarkus_solr.id
  repository = github_repository.quarkus_solr.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_solr" {
  for_each = { for tm in ["lizzyTheLizard"] : tm => tm }
  team_id  = github_team.quarkus_solr.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_solr" {
  name        = "main"
  repository  = github_repository.quarkus_solr.name
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