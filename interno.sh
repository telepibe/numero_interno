#!/usr/bin/env bash
# Requires bash >4

# Bash unofficial strict mode
set -euo pipefail
IFS=$'\n\t'

db="db.example"

# $search defaults to empty string if its not defined.
search=${1:-}

if [[ -z $search ]]; then
	echo "Uso: $0 nombre|interno"
	exit 1
fi

actual_dir="$( dirname "$( readlink -f "$0")")"

# Loads $tels array with lines of file. Keeps newlines.
mapfile tels <"${actual_dir}/${db}"

# TODO do not take accents into account (fuzzy search?)
regex=".*${search}.*" 

# TODO find a way to set every option without eval
function return_shopt_status() {
	local IFS=$' '	# else shopt_status has one element
	local -n status=$1 # reference by name
	# shellcheck disable=SC2034
	status=( $(shopt -p "$2" || true) ) # it's not clear if can fail
}

shopt_status=""
return_shopt_status shopt_status nocasematch

shopt -s nocasematch
declare -i match=0
for interno in "${tels[@]}"; do
	if [[ ${interno} =~ $regex ]]; then
		# supress extra newline
		echo -n "${BASH_REMATCH[0]}"
		match+=1
	fi
done

# Go back to how it was before
${shopt_status[*]}

if (( match==0 )); then
	exit 1
fi
