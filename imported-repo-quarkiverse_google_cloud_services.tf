resource "github_repository" "quarkiverse_google_cloud_services" {
             name                    = "quarkiverse-google-cloud-services"
             description             = "Google Cloud Services Quarkus Extensions"
             homepage_url            = ""
             private                 = false
             has_issues              = true
             has_projects            = true
             has_wiki                = true
             
             allow_merge_commit      = true
             allow_squash_merge      = true
             allow_rebase_merge      = true
             delete_branch_on_merge  = false
             has_downloads           = true
             
             
             
             default_branch          = "master"
             archived                = false
             
             topics                  = [
             ]
           }
