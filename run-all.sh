#!/usr/bin/env bash
# Runs every demo from the video, in script order.
set -uo pipefail
cd "$(dirname "$0")"

fail=0
for d in 01-bytecode 02-llvm 03-wasm 04-jit; do
  echo
  echo "════════════════════════════════════════════════════════"
  echo "  $d"
  echo "════════════════════════════════════════════════════════"
  if ! ./"$d"/run.sh; then
    echo "!! $d failed — see the Requirements table in README.md"
    fail=1
  fi
done

echo
[ "$fail" -eq 0 ] && echo "✅ all four demos ran" || echo "⚠️  some demos were skipped (missing tools)"
exit "$fail"
