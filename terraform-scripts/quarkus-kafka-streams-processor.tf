# Create repository
resource "github_repository" "quarkus_kafka_streams_processor" {
  name                   = "quarkus-kafka-streams-processor"
  description            = "Easily build resilient Kafka Streams topologies based on the Processor API"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-kafka-streams-processor/dev/index.html"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_wiki               = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension", "kafka-streams", "resiliency"]
}

# Create team
resource "github_team" "quarkus_kafka_streams_processor" {
  name                      = "quarkiverse-kafka-streams-processor"
  description               = "kafka-streams-processor team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_kafka_streams_processor" {
  team_id    = github_team.quarkus_kafka_streams_processor.id
  repository = github_repository.quarkus_kafka_streams_processor.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_kafka_streams_processor" {
  for_each = { for tm in ["Annlazar", "afatnassi1a", "bsoaressimoes", "csemaan1A", "edeweerd1A",
  "flazarus1A", "ivantchomgue1a", "ldouais1a", "lmartella1", "tryasta", "rquinio1A", "vietk"] : tm => tm }
  team_id  = github_team.quarkus_kafka_streams_processor.id
  username = each.value
  role     = "maintainer"
}
