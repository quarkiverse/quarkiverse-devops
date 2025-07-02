# Create repository
resource "github_repository" "quarkus_rage4j" {
  name                   = "quarkus-rage4j"
  description            = "Rage4j is a java library thats helps evaluate LLM's based on scientifically grounded metrics"
  homepage_url           = "https://explore-de.github.io/rage4j/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "large-language-models", "llms", "continuous-integration", "ai", "llm-testing", "semantic-evaluation", "testing-library", "langchain4j", "openai"]
}

# Create team
resource "github_team" "quarkus_rage4j" {
  name                      = "quarkiverse-rage4j"
  description               = "rage4j team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_rage4j" {
  team_id    = github_team.quarkus_rage4j.id
  repository = github_repository.quarkus_rage4j.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_rage4j" {
  for_each = { for tm in ["d135-1r43", "vladislavkn", "vvilip"] : tm => tm }
  team_id  = github_team.quarkus_rage4j.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_rage4j" {
  name        = "main"
  repository  = github_repository.quarkus_rage4j.name
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