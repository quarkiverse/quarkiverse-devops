resource "github_team" "quarkiverse_wiki" {
  name        = "quarkiverse-wiki"
  description = "Users/bots that can commit directly to quarkiverse wiki"
  privacy     = "closed"
}

resource "github_team_membership" "quarkiverse_wiki_maxandersen" {
   team_id  = "4101822"
   username = "maxandersen"
   role     = "maintainer"
 }

resource "github_team_membership" "quarkiverse_wiki_quarkusbot" {
   team_id  = "4101822"
   username = "quarkusbot"
   role     = "member"
 }

resource "github_team_repository" "quarkiverse_wiki_quarkiverse" {
    team_id    = "4101822"
    repository = "quarkiverse"
    permission = "pull"
  }

resource "github_team_repository" "quarkiverse_wiki_quarkiverse_wiki" {
    team_id    = "4101822"
    repository = "quarkiverse-wiki"
    permission = "pull"
  }
