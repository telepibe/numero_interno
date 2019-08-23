#!/usr/bin/env bash
# Requires bash >4
set -- iri
set -euo pipefail
IFS=$'\n\t'

# $search defaults to empty string if its not defined.
search=${1:-}

if [[ -z $search ]]; then
	echo "Uso: $0 nombre|interno"
	exit 1
fi

# Loads $tels array with lines of file. Keeps newlines.
mapfile tels <db.txt

regex=".*${search}.*"

# shopt will return 1 if is not set
shopt_match_status=( $(shopt -p nocasematch || true) )

shopt -s nocasematch

for interno in "${tels[@]}"; do
	[[ ${interno} =~ $regex ]] && echo "${BASH_REMATCH[0]}"
done

# Go back to how it was before
${shopt_match_status[*]}