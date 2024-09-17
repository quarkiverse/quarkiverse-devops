#!/bin/bash

#set -o xtrace

BRANCH_NAME=
PR_TITLE=
PR_BODY=
JBANG_SCRIPT=
FILTER_REPOS=.

# This script is used to patch all Quarkiverse repositories
while getopts "b:t:m:j:f:" OPT; do
  case "$OPT" in
  "b") BRANCH_NAME=$OPTARG ;;
  "t") PR_TITLE=$OPTARG ;;
  "m") PR_BODY=$OPTARG ;;
  "j") JBANG_SCRIPT=$OPTARG ;;
  "f") FILTER_REPOS=$OPTARG ;;
  "?") exit -1 ;;
  esac
done

# Check that all parameters are set
if [ -z "$BRANCH_NAME" ]; then
  echo "Branch name is not set"
  exit -1
fi
if [ -z "$PR_TITLE" ]; then
  echo "Pull-request title is not set"
  exit -1
fi
if [ -z "$PR_BODY" ]; then
  echo "Pull-request body is not set"
  exit -1
fi
if [ -z "$JBANG_SCRIPT" ]; then
  echo "JBang script is not set"
  exit -1
fi

apply_patch() {
  # Invoke the JBang script
  jbang run $JBANG_SCRIPT $1
}

CURRENT_DIR=$(pwd)
# Create temporary directory
WORK_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')
echo "Working in temp directory $WORK_DIR"
cd $WORK_DIR

# Iterate through all Quarkiverse repositories and apply the patch
gh repo list quarkiverse --jq '.[].nameWithOwner' --topic quarkus-extension --json nameWithOwner --no-archived -L 1000 |  sort | grep $FILTER_REPOS | while read repo; do
  cd $WORK_DIR
  echo -e "\n-> Processing $repo"
  # Clone the repository
  gh repo clone $repo -- -q
  # Change directory
  cd $(basename $repo)
  # Skip if the branch already exists
  if [[ -z $(git ls-remote --heads origin $BRANCH_NAME) ]]; then
    # Checkout the branch
    git switch -c $BRANCH_NAME
    # Invoke the patch function
    apply_patch $repo
    # Check if there are changes in the git repository
    if [[ -n $(git status -s) ]]; then
      # Invoke formatter
      mvn clean process-sources
      # Commit the changes
      git add . && git commit -m "$PR_TITLE"
      # Push the changes
      git push origin $BRANCH_NAME
      # Create the pull-request
      gh pr create --title "$PR_TITLE" --body "$PR_BODY" | tee -a $CURRENT_DIR/pull-requests.txt
    else
      echo "No changes in $repo"
    fi
  else
    echo "No changes in $repo"
  fi
done

# Remove temporary directory
echo "Cleaning up temp directory $WORK_DIR"
rm -rf $WORK_DIR
