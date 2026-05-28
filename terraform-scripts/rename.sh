#!/bin/sh
set -euo pipefail

: ${1:?"Usage: $0 <old_name> <new_name> (e.g. $0 quarkus_statiq quarkus_roq)"}
: ${2:?"Usage: $0 <old_name> <new_name> (e.g. $0 quarkus_statiq quarkus_roq)"}

OLD=$1
NEW=$2

echo "Renaming Terraform resources from '$OLD' to '$NEW'"
echo ""

terraform state list | grep "\\.${OLD}" | while read -r old_addr; do
  new_addr="${old_addr//${OLD}/${NEW}}"
  echo "terraform state mv '$old_addr' '$new_addr'"
done

echo ""
echo "Review the commands above. Run with | sh to execute:"
echo "  $0 $OLD $NEW | sh"
