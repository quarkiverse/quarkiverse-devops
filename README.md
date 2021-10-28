# Terraform scripts for the Quarkiverse

Terraform scripts are executed in the [Terraform Cloud]( https://app.terraform.io/app/quarkiverse/workspaces/quarkiverse-devops).


## Planning the execution

- Login to the Terraform Cloud using `terraform login`
- Run `terraform init` to initialize the repository
- Run `terraform plan` to visualize the execution plan


IMPORTANT: Because the VCS is the single source of truth, you can't apply terraform scripts manually using `terraform apply`. 

## Workflow for new repositories

New repositories are submitted via Pull Requests to the `repositories/` directory in this repository:

- Add a new `.tf` script in the `repositories` directory with the following structure: 

```terraform
# Create repository
resource "github_repository" "quarkus_UNIQUE_NAME" {
  name = "quarkus-DASHED-NAME"
  description = "Quarkus extension for Sentry, a self-hosted or cloud-based error monitoring solution"
  delete_branch_on_merge = true
  topics = ["quarkus-extension"]
}

# Create team
resource "github_team" "quarkus_UNIQUE_NAME" {
  name                      = "quarkiverse-DASHED-NAME"
  description               = "Quarkiverse team for the Sentry Logging extension"
  create_default_maintainer = false
  privacy                   = "closed"

}

# Add team to repository
resource "github_team_repository" "quarkus_UNIQUE_NAME" {
  team_id    = github_team.quarkus_UNIQUE_NAME.id
  repository = github_repository.quarkus_UNIQUE_NAME.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_UNIQUE_NAME" {
  for_each = { for tm in ["GITHUB_ID"] : tm => tm }
  team_id  = github_team.quarkus_UNIQUE_NAME.id
  username = each.value
  role = "maintainer"
}
```

Where:

- `UNIQUE_NAME`: should be the extension name using underline (`_`) as separator (eg. `logging_sentry`)
- `DASHED_NAME`: the same extension name using dashes (`-`) as separator (eg. `logging-sentry`)
- `GITHUB_ID`: the Github user names that will have maintain access to the repository

- Run `terraform plan` to check if the execution plan is expected.
- Submit a Pull Request with the changes
- When the PR is merged, a job will be run in [Terraform cloud](https://app.terraform.io/app/quarkiverse/workspaces/quarkiverse-devops/runs) applying the changes
