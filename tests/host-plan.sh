#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/lib/host-plan.sh"
[[ "$(mncm_host_profile 10 none)" == laptop ]]
[[ "$(mncm_host_profile 3 none)" == desktop ]]
[[ "$(mncm_host_profile 10 kvm)" == vm ]]
[[ "$(mncm_host_profile unknown unknown)" == unknown ]]
[[ "$(mncm_host_profile 'untrusted text' none)" == unknown ]]
printf '%s\n' 'PASS: pure laptop/desktop/VM/unknown host classification.'
