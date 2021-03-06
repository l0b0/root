#!/usr/bin/env bash
set -o errexit -o noclobber -o nounset

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_directory="$(dirname "$directory")"

shopt -s extglob
for module_path in "${repository_directory}/modules/"!(battery_indicator|development_tools|general_development_tools|hardware_drivers|hypervisor|my_firewall|steam|virtual_machine_manager|x_server_resource_configuration|x_server_video_driver)
do
    module_name="$(basename "$module_path")"
    if ! [[ -e "${directory}/modules/$(basename "$module_path")/test.sh" ]]
    then
        printf 'No tests found for module: %s\n' "$module_name"
        exit_code=1
    fi
done

exit "${exit_code-0}"
