#!/usr/bin/env bash
# Video 8:20 — the JIT changes its mind mid-flight.
set -euo pipefail
cd "$(dirname "$0")"

echo "==> javac Demo.java"
javac Demo.java

echo
echo "==> java Demo           (cold vs hot — expect roughly 8x)"
java Demo

echo
echo "==> java -XX:+PrintCompilation Demo | grep Demo::sum"
echo "    tier 3 = C1, tier 4 = C2. Watch it escalate, then discard its own older version."
java -XX:+PrintCompilation Demo 2>&1 | grep 'Demo::sum'
