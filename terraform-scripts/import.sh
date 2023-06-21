#!/bin/sh
 : ${1:?"Must specify the team ID"}
 : ${2:?"Must specify the repository to import "}
 : ${3:?"Must specify the repository using underlines"}
 : ${4:?"Must specify the collaborator login"}
 : ${4:?"Must specify the default branch"}

TEAM=$1
REPO=$2
REPO_UNDER=$3
COLLAB=$4
BRANCH=$5

terraform import github_repository.${REPO_UNDER} ${REPO} 
terraform import github_team.${REPO_UNDER} ${TEAM} 
terraform import github_team_repository.${REPO_UNDER} ${TEAM}:${REPO}
terraform import "github_team_membership.${REPO_UNDER}[\"${COLLAB}\"]" ${TEAM}:${COLLAB} 
terraform import github_branch.${REPO_UNDER} ${REPO}:${BRANCH}
terraform import github_branch_default.${REPO_UNDER} ${REPO}

terraform plan