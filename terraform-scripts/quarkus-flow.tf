# Create repository
resource "github_repository" "quarkus_flow" {
  name                   = "quarkus-flow"
  description            = "Workflow Runtime Engine based on CNCF Workflow Specification for Agentic Workflows"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-flow/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "workflows", "cncf", "specification", "agentic-workflows", "ai", "langchain4j"]
}

###### Maintainers Team #############
# Create team
resource "github_team" "quarkus_flow" {
  name                      = "quarkiverse-flow"
  description               = "flow team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_flow" {
  team_id    = github_team.quarkus_flow.id
  repository = github_repository.quarkus_flow.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_flow" {
  for_each = { for tm in ["ricardozanini", "fjtirado"] : tm => tm }
  team_id  = github_team.quarkus_flow.id
  username = each.value
  role     = "maintainer"
}

###### Triage Team #############
# Create triage team
resource "github_team" "quarkus_flow_triage" {
  name                      = "quarkiverse-flow-triage"
  description               = "triage flow team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_flow_triage" {
  team_id    = github_team.quarkus_flow_triage.id
  repository = github_repository.quarkus_flow.name
  permission = "triage"
}

# Add users to the team
resource "github_team_membership" "quarkus_flow_triage" {
  for_each = { for tm in ["wmedvede", "gmunozfe", "domhanak", "mcruzdev", "domhanak"] : tm => tm }
  team_id  = github_team.quarkus_flow_triage.id
  username = each.value
  role     = "triage"
}
###### End Triage Team #############

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_flow" {
  name        = "main"
  repository  = github_repository.quarkus_flow.name
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
