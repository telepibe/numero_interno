#!/usr/bin/env bash
# Requires bash >4
set -euo pipefail
IFS=$'\n\t'
set -- zzz
# $search defaults to empty string if its not defined.
search=${1:-}

if [[ -z $search ]]; then
	echo "Uso: $0 nombre|interno"
	exit 1
fi

actual_dir="$( dirname "$( readlink -f "$0")")"

# Loads $tels array with lines of file. Keeps newlines.
mapfile tels <${actual_dir}/db.txt

regex=".*${search}.*"

_ifs=$IFS
IFS=' ' # else shopt_match_status has one element

# shopt will return 1 if is not set
shopt_match_status=( $(shopt -p nocasematch || true) )

IFS=$_ifs

shopt -s nocasematch
declare -i match=0
for interno in "${tels[@]}"; do
	# supress extra newline
	if [[ ${interno} =~ $regex ]];then
		echo -n "${BASH_REMATCH[0]}"
		match+=1
	fi
done

# Go back to how it was before
${shopt_match_status[*]}

if (( match==0 )); then
	exit 1
fi 