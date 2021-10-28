terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.13.0"
    }
  }

  backend "remote" {
    organization = "quarkiverse"

    workspaces {
      name = "quarkiverse-devops"
    }
  }

  required_version = "~> 1.0.5"
}

provider "github" {}

# Retrieve information about the currently (PAT) authenticated user
data "github_user" "self" {
  username = ""
}

module "repositories" {
  source = "./repositories"
}