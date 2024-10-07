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

  required_version = "~> 1.9.0"
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

locals {
  # Application IDs installed in the Quarkiverse organization
  # These applications are enabled on a per-repository basis
  applications = {
    # Renovate - https://github.com/marketplace/renovate
    renovate = "34650047"
  }
}
