#!/usr/bin/env bash
# Pure classification of supplied facts, never reads personal files or changes hardware.
mncm_host_profile() {
    local chassis="${1:-unknown}" virtualization="${2:-unknown}"
    if [[ "$virtualization" != unknown && "$virtualization" != none && -n "$virtualization" ]]; then
        printf '%s\n' vm
    else
        case "$chassis" in
            8|9|10|14|30|31|32) printf '%s\n' laptop ;;
            3|4|5|6|7|13|15|16) printf '%s\n' desktop ;;
            *) printf '%s\n' unknown ;;
        esac
    fi
}
