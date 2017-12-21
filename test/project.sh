#!/usr/bin/env bash
set -o errexit -o noclobber -o nounset

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_directory="$(dirname "$directory")"

for module_path in "${repository_directory}/modules/"
do
    module_name="$(basename "$module_path")"
    if ! [[ -e "${directory}/modules/$(basename "$module_path")/test.sh" ]]
    then
        printf 'No tests found for module: %s\n' "$module_name"
        exit_code=1
    fi
done

exit "${exit_code-0}"
