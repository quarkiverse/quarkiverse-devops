resource "github_team" "quarkiverse_jberet" {
  name        = "quarkiverse-jberet"
  description = "JBeret extension"
  privacy     = "closed"
}

resource "github_team_repository" "quarkiverse_jberet_quarkiverse_jberet" {
    team_id    = "4130738"
    repository = "quarkiverse-jberet"
    permission = "pull"
  }
