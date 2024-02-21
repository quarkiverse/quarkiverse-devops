# Create repository
resource "github_repository" "quarkus_oidc_proxy" {
  name                   = "quarkus-oidc-proxy"
  description            = "OpenID Connect Proxy"
  homepage_url           = "https://some-url/"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "oidc", "proxy", "openid-connect", "oauth2"]
}

# Create team
resource "github_team" "quarkus_oidc_proxy" {
  name                      = "quarkiverse-oidc-proxy"
  description               = "oidc-proxy team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_oidc_proxy" {
  team_id    = github_team.quarkus_oidc_proxy.id
  repository = github_repository.quarkus_oidc_proxy.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_oidc_proxy" {
  for_each = { for tm in ["sberyozkin"] : tm => tm }
  team_id  = github_team.quarkus_oidc_proxy.id
  username = each.value
  role     = "maintainer"
}
