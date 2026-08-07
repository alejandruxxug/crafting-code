#!/usr/bin/env bash
# Video 3:10 — Nero's segment. Source -> bytecode -> read the bytecode back.
set -euo pipefail
cd "$(dirname "$0")"

echo "==> javac Add.java"
javac Add.java

echo
echo "==> javap -c Add        (the shulker box, opened)"
javap -c Add

echo
echo "==> javap -v Add        (the constant pool — an indexed array)"
javap -v Add | sed -n '/Constant pool:/,/^{/{/^{/!p;}'
