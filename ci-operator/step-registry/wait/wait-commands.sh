#!/bin/bash
set -eo pipefail
NEEDED_KC="${KUBECONFIG}"
[ -f "${MC_KUBECONFIG_FILE}" ] && echo "The MC_KUBECONFIG_FILE env var exists" && NEEDED_KC="${MC_KUBECONFIG_FILE}" || echo "The MC_KUBECONFIG_FILE env var does not exist"
T1=$(date '+%Y-%m-%dT%H:%M:%S%:z')
DUR=10hours
while true; do
  T2=$(date '+%s')
  T3=$(date --date "$T1 + $DUR" '+%s')
  if [ $T2 -ge $T3 ]; then
    echo "$(date '+%Y-%m-%dT%H:%M:%S%:z'): Elapsed $DUR. Ending the wait-dynamic-time step."
    break
  fi
  if oc --kubeconfig "$NEEDED_KC" get ns xxia-control-del > /dev/null; then
    echo "The xxia-control-del namespace appears. Ending the wait-dynamic-time step."
    break
  fi
  echo "Sleeping 10m again ..."
  sleep 10m
done
SLEEP_DURATION=10m
sleep "$SLEEP_DURATION" &
wait
