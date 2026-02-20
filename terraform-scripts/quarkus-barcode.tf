# Create repository
resource "github_repository" "quarkus_barcode" {
  name                   = "quarkus-barcode"
  description            = "Barcode and QRCode support in Quarkus"
  homepage_url           = "https://github.com/zxing/zxing"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "barcode", "qrcode", "barcode4j", "zxing", "barbecue"]
}

# Create team
resource "github_team" "quarkus_barcode" {
  name                      = "quarkiverse-barcode"
  description               = "barcode team"
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_barcode" {
  team_id    = github_team.quarkus_barcode.id
  repository = github_repository.quarkus_barcode.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_barcode" {
  for_each = { for tm in ["melloware", "turing85", "FroMage"] : tm => tm }
  team_id  = github_team.quarkus_barcode.id
  username = each.value
  role     = "maintainer"
}
