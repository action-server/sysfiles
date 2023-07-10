#!/bin/sh

set -e

IFS='
'

SCRIPT_NAME="$(basename "$0")"

print_error(){
	message="$1"
	printf '%s\n' "Error: ${message}" >&2

}

create_symbolic_link(){
	dest_path="${1}"

	files="$(find . \( -name ${SCRIPT_NAME} -o -name '\.git' -o -name '.gitignore' \) -prune -o -type f -print)"

	for file in ${files}; do
		parent_path="$(dirname "${file}")"
		mkdir -p "${dest_path}/${parent_path}"
		ln -f "$(pwd)/${file}" "${dest_path}/${file}"
	done
}

main(){
	dest_path="${1}"

	if [ "${#}" -ne 1 ]; then
		print_error 'Usage: ./install.sh <destination_full_path>'
		exit 1
	fi

	if [ ! -d "${dest_path}" ]; then
		print_error "'${dest_path}' is not a directory."
		exit 1
	fi

	create_symbolic_link "${@}"
}

main "${@}"
