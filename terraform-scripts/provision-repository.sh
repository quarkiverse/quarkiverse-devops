#!/usr/bin/env bash
#
# Provision a new Quarkiverse repository following the "Workflow for new
# repositories" section of the README.
#
# It generates the Terraform script (terraform-scripts/quarkus-<dashed-name>.tf)
# and registers the team in the .github/CODEOWNERS file.
#
# Usage:
#   ./provision-repository.sh <name> -m <github-id> [-m <github-id>...] \
#     [-d "description"] [-t topic]...
#
#   <name>       The extension name. It can be given with dashes (dashed name,
#                e.g. logging-sentry) or underscores (unique name, e.g.
#                logging_sentry). The other form is derived automatically:
#                the unique name is generated from the dashed name.
#   -m           A GitHub username that gets maintainer access. Required, and
#                can be repeated to add several maintainers.
#   -d           Optional short description of the extension.
#   -t           Optional repository topic. Can be repeated to add several.
#                The "quarkus-extension" topic is always included.
#
# Example:
#   ./provision-repository.sh logging-sentry -m alice -m bob \
#     -d "Send logs to Sentry" -t logging -t sentry
#
set -euo pipefail

usage() {
  grep '^#' "$0" | sed '1d;s/^#\s\?//'
  exit "${1:-0}"
}

# Resolve paths relative to this script so it can be run from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEOWNERS_FILE="$(cd "${SCRIPT_DIR}/.." && pwd)/.github/CODEOWNERS"

DESCRIPTION="A cool description"
NAME=""
GITHUB_IDS=()
TOPICS=()

# Parse arguments.
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage 0
      ;;
    -d|--description)
      [[ $# -ge 2 ]] || { echo "Error: -d requires an argument" >&2; usage 1; }
      DESCRIPTION="$2"
      shift 2
      ;;
    -t|--topic)
      [[ $# -ge 2 ]] || { echo "Error: -t requires an argument" >&2; usage 1; }
      TOPICS+=("$2")
      shift 2
      ;;
    -m|--maintainer)
      [[ $# -ge 2 ]] || { echo "Error: -m requires an argument" >&2; usage 1; }
      GITHUB_IDS+=("$2")
      shift 2
      ;;
    -*)
      echo "Error: unknown option '$1'" >&2
      usage 1
      ;;
    *)
      if [[ -z "${NAME}" ]]; then
        NAME="$1"
      else
        echo "Error: unexpected argument '$1'" >&2
        usage 1
      fi
      shift
      ;;
  esac
done

if [[ -z "${NAME}" || ${#GITHUB_IDS[@]} -eq 0 ]]; then
  echo "Error: a name and at least one maintainer (-m) are required" >&2
  usage 1
fi

# Derive both name forms. The dashed name is the source of truth; the unique
# name is generated from it by replacing dashes with underscores.
DASHED_NAME="${NAME//_/-}"
UNIQUE_NAME="${DASHED_NAME//-/_}"

TF_FILE="${SCRIPT_DIR}/quarkus-${DASHED_NAME}.tf"

if [[ -e "${TF_FILE}" ]]; then
  echo "Error: ${TF_FILE} already exists" >&2
  exit 1
fi

# Build the "for_each" list of maintainers, e.g. "alice", "bob"
MAINTAINERS=""
for id in ${GITHUB_IDS[@]+"${GITHUB_IDS[@]}"}; do
  [[ -n "${MAINTAINERS}" ]] && MAINTAINERS+=", "
  MAINTAINERS+="\"${id}\""
done

# Build the topics list. "quarkus-extension" is always present, followed by any
# extra topics passed with -t, e.g. "quarkus-extension", "logging", "sentry"
TOPICS_LIST="\"quarkus-extension\""
for topic in ${TOPICS[@]+"${TOPICS[@]}"}; do
  TOPICS_LIST+=", \"${topic}\""
done

# Generate the Terraform script.
cat > "${TF_FILE}" <<EOF
# Create repository
resource "github_repository" "quarkus_${UNIQUE_NAME}" {
  name                   = "quarkus-${DASHED_NAME}"
  description            = "${DESCRIPTION}"
  homepage_url           = "https://docs.quarkiverse.io/quarkus-${DASHED_NAME}/dev"
  allow_update_branch    = true
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  topics                 = [${TOPICS_LIST}]
}

# Enable vulnerability alerts
resource "github_repository_vulnerability_alerts" "quarkus_${UNIQUE_NAME}" {
  repository = github_repository.quarkus_${UNIQUE_NAME}.name
  enabled    = true
}

# Create team
resource "github_team" "quarkus_${UNIQUE_NAME}" {
  name           = "quarkiverse-${DASHED_NAME}"
  description    = "${DASHED_NAME} team"
  privacy        = "closed"
  parent_team_id = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_${UNIQUE_NAME}" {
  team_id    = github_team.quarkus_${UNIQUE_NAME}.id
  repository = github_repository.quarkus_${UNIQUE_NAME}.name
  permission = "push"
}

# Add users to the team
resource "github_team_membership" "quarkus_${UNIQUE_NAME}" {
  for_each = { for tm in [${MAINTAINERS}] : tm => tm }
  team_id  = github_team.quarkus_${UNIQUE_NAME}.id
  username = each.value
  role     = "maintainer"
}

# Protect main branch using a ruleset
resource "github_repository_ruleset" "quarkus_${UNIQUE_NAME}" {
  name        = "main"
  repository  = github_repository.quarkus_${UNIQUE_NAME}.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = data.github_app.quarkiverse_ci.id
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  rules {
    # Prevent force push
    non_fast_forward = true
    # Require pull request reviews before merging
    pull_request {

    }
  }
}
EOF

echo "Created ${TF_FILE}"

# Register the team in CODEOWNERS. The new entry is inserted at its
# alphabetical position (by path) without reordering the existing lines, so the
# diff stays minimal. Owners are aligned at column 65 (path padded to 64).
CODEOWNERS_PATH="terraform-scripts/quarkus-${DASHED_NAME}.tf"
CODEOWNERS_TEAM="@quarkiverse/quarkiverse-${DASHED_NAME}"

if [[ ! -f "${CODEOWNERS_FILE}" ]]; then
  echo "Warning: ${CODEOWNERS_FILE} not found, skipping CODEOWNERS update" >&2
elif grep -q "^${CODEOWNERS_PATH}[[:space:]]" "${CODEOWNERS_FILE}"; then
  echo "Entry for ${CODEOWNERS_PATH} already present in CODEOWNERS, skipping"
else
  CODEOWNERS_LINE="$(printf '%-64s%s' "${CODEOWNERS_PATH}" "${CODEOWNERS_TEAM}")"
  # Insert before the first existing entry whose path sorts after the new one;
  # append at the end if none does. Existing lines are left untouched.
  TMP_FILE="$(mktemp)"
  LC_ALL=C awk -v newline="${CODEOWNERS_LINE}" -v newpath="${CODEOWNERS_PATH}" '
    !inserted && $1 > newpath { print newline; inserted = 1 }
    { print }
    END { if (!inserted) print newline }
  ' "${CODEOWNERS_FILE}" > "${TMP_FILE}"
  mv "${TMP_FILE}" "${CODEOWNERS_FILE}"
  echo "Added CODEOWNERS entry: ${CODEOWNERS_LINE}"
fi

echo "Done. Run 'terraform plan' to review the execution plan before submitting a PR."
