#!/usr/bin/env sh
# Run the whole tests/ suite and tally ✅/❌. Exits non-zero if anything fails.
# Each tests/*.metta carries its own `!(test …)` assertions (a failing test
# HALTS that file). Imports inside the tests are repo-root-relative, so the
# suite must run from the repo root — this script cd's there itself.
#
# Usage:  sh tests/run_suite.sh          (from anywhere in the repo)
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO=$(dirname "$SCRIPT_DIR")
RUNNER="$REPO/../PeTTa/run.sh"
cd "$REPO" || exit 2

total_pass=0; total_fail=0; problems=""
for f in tests/*.metta; do
  name=$(basename "$f" .metta)
  out=$(sh "$RUNNER" "$f" < /dev/null 2>&1 | grep -E '✅|❌')
  p=$(printf '%s\n' "$out" | grep -c '✅')
  fl=$(printf '%s\n' "$out" | grep -c '❌')
  total_pass=$((total_pass + p)); total_fail=$((total_fail + fl))
  if [ "$fl" -gt 0 ]; then
    printf '  %-18s ✅ %3s  ❌ %s   <== FAIL\n' "$name" "$p" "$fl"; problems="$problems $name"
  elif [ "$p" -eq 0 ]; then
    printf '  %-18s (no tests emitted — file errored?)\n' "$name"; problems="$problems $name(err)"
  else
    printf '  %-18s ✅ %3s\n' "$name" "$p"
  fi
done
echo "-----------------------------------------"
printf 'TOTAL  ✅ %s   ❌ %s\n' "$total_pass" "$total_fail"
[ "$total_fail" -eq 0 ] && [ -z "$problems" ] && exit 0
printf 'PROBLEMS:%s\n' "$problems"; exit 1
