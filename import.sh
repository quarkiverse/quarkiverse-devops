#!/bin/sh
 : ${1:?"Must specify the team ID"}
 : ${2:?"Must specify the repository to import "}
 : ${3:?"Must specify the repository using underlines"}
 : ${4:?"Must specify the collaborator login"}

TEAM=$1
REPO=$2
REPO_UNDER=$3
COLLAB=$4

echo terraform import github_repository.${REPO_UNDER} ${REPO} 
terraform import github_repository.${REPO_UNDER} ${REPO} 
echo terraform import github_team.${REPO_UNDER} ${TEAM} 
terraform import github_team.${REPO_UNDER} ${TEAM} 
echo terraform import github_team_repository.${REPO_UNDER} ${TEAM}:${REPO}
terraform import github_team_repository.${REPO_UNDER} ${TEAM}:${REPO}
echo terraform import "github_team_membership.${REPO_UNDER}[\"${COLLAB}\"]" ${TEAM}:${COLLAB} 
terraform import "github_team_membership.${REPO_UNDER}[\"${COLLAB}\"]" ${TEAM}:${COLLAB} 

terraform plan