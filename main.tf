# Define provider
provider "github" {
  version      = "~> 3.0.0"
  token        = var.gh_token
  organization = var.gh_org
}
