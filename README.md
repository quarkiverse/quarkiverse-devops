# Terraform scripts for the Quarkiverse

Terraform scripts are executed in the [Terraform Cloud]( https://app.terraform.io/app/quarkiverse/workspaces/quarkiverse-devops).


## Planning the execution

- Login to the Terraform Cloud using `terraform login`
- Export the following environment variables:
```bash
export GITHUB_OWNER=quarkiverse 
export GITHUB_TOKEN=$(git config github.token)
```
- Run `terraform init` to initialize the repository
- Run `terraform plan` to visualize the execution plan

IMPORTANT: Because the VCS is the single source of truth, you can't apply terraform scripts manually using `terraform apply`. 

## Workflow for new repositories

New repositories are submitted via Pull Requests to the root directory in this repository:

1. Add a new `.tf` script in the root directory with the following structure: 

```terraform
# Create repository
resource "github_repository" "quarkus_UNIQUE_NAME" {
  name                   = "quarkus-DASHED-NAME"
  description            = "A cool description"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_UNIQUE_NAME" {
  name                      = "quarkiverse-DASHED-NAME"
  description               = "DASHED-NAME team"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
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
  role     = "maintainer"
}
```
- `UNIQUE_NAME`: should be the extension name using underline (`_`) as separator (eg. `logging_sentry`)
- `DASHED_NAME`: the same extension name using dashes (`-`) as separator (eg. `logging-sentry`)
- `GITHUB_ID`: the Github user names that will have maintain access to the repository

2. Run `terraform plan` to check if the execution plan is expected.
3. Add an entry in  the `.github/CODEOWNERS` file
4. Submit a Pull Request with the changes
5. When the PR is merged, a job will be run in [Terraform cloud](https://app.terraform.io/app/quarkiverse/workspaces/quarkiverse-devops/runs) applying the changes

If you need any other configuration, check the [GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest/docs) documentation in the Terraform website.

## Installing applications

Terraform scripts [allow you to install applications](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/app_installation_repository) only if they are already installed in the Quarkiverse organization. 

Check the [list of installed applications](https://github.com/organizations/quarkiverse/settings/installations) in the organization and add the corresponding [local](https://github.com/quarkiverse/quarkiverse-devops/blob/main/main.tf#L35) to your `github_app_installation_repository` resource

For example, if you want to enable [Stale](https://github.com/marketplace/stale) in your repository, add the following snippet to the .tf file:

```terraform
# Enable apps in repository
resource "github_app_installation_repository" "quarkus_UNIQUE_NAME" {
  for_each = { for app in [local.applications.stale] : app => app }
  # The installation id of the app (in the organization).
  installation_id = each.value
  repository      = github_repository.quarkus_UNIQUE_NAME.name
}
```
