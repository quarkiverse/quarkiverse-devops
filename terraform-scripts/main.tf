terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  backend "remote" {
    organization = "quarkiverse"

    workspaces {
      name = "quarkiverse-devops"
    }
  }

  required_version = "~> 1.14.0"
}

provider "github" {}

# Retrieve information about the currently (PAT) authenticated user
data "github_user" "self" {
  username = ""
}

# Return quarkiverse-members team ID
data "github_team" "quarkiverse_members" {
  slug = "quarkiverse-members"
}

data "github_app" "quarkiverse_ci" {
  slug = "quarkiverse-ci"
}

locals {
  # Installation IDs installed in the Quarkiverse organization
  # These applications are enabled on a per-repository basis
  applications = {
    # LGTM - https://github.com/marketplace/lgtm
    lgtm = "24341616"
    # Renovate - https://github.com/marketplace/renovate
    renovate = "34650047"
    # This enables a webhook to send events from these repositories
    # to Fedora Messaging,
    # which is used by a separately configured Sync2Jira instance
    # to replicate GitHub issues to issues.redhat.com.
    # The point is to allow Red Hat engineers to use this internally
    # to prioritize their work.
    # Only public information is shared.
    # See:
    # https://github.com/release-engineering/Sync2Jira/
    # https://github.com/fedora-infra/webhook-to-fedora-messaging/
    # https://issues.redhat.com/projects/GHQKIVERSE
    sync2jira_redhat = "60685343"
  }
}
