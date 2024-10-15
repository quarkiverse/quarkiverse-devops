terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    quay = {
      source  = "enthought/quay"
      version = "~> 0.5.1"
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

provider "quay" {
  url = "https://quay.io"
}

# Retrieve information about the currently (PAT) authenticated user
data "github_user" "self" {
  username = ""
}

# Return quarkiverse-members team ID
data "github_team" "quarkiverse_members" {
  slug = "quarkiverse-members"
}

data "quay_organization" "quarkiverse" {
  name = "quarkiverse"
}

locals {
  # Application IDs installed in the Quarkiverse organization
  # These applications are enabled on a per-repository basis
  applications = {
    # LGTM - https://github.com/marketplace/lgtm
    lgtm = "24341616"
    # Renovate - https://github.com/marketplace/renovate
    renovate = "34650047"
  }
}
