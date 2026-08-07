#!/usr/bin/env bash
# Video 5:45 — Limon's segment. One IR, many machines.
set -euo pipefail
cd "$(dirname "$0")"

LLC="/opt/homebrew/opt/llvm/bin/llc"
[ -x "$LLC" ] || LLC="llc"

echo "########## 1. FRONT END — C becomes IR ##########"
echo
echo "==> clang -O0   (straight out of the front end)"
clang -O0 -S -emit-llvm -fno-discard-value-names -o - add.c | sed -n '/^define/,/^}/p'

echo
echo "########## 2. MIDDLE END — the grindstone ##########"
echo
echo "==> clang -O1   (same source, after optimization)"
clang -O1 -S -emit-llvm -fno-discard-value-names -o - add.c | sed -n '/^define/,/^}/p'
echo
echo "    9 instructions -> 2. Nothing yet knows which CPU we're targeting."

echo
echo "########## 3. BACK END — one ingot, three worlds ##########"
echo
echo "    Lowering the SAME hand-written add.ll to three architectures."
for arch in arm64 x86-64 riscv64; do
  echo
  echo "==> llc -march=$arch add.ll"
  "$LLC" -march="$arch" -o - add.ll 2>/dev/null \
    | grep -vE '^\s*[.#;]|^$|^\s*##' | sed 's/^/    /'
done
echo
echo "    Same file. ARM axe, x86 pickaxe, RISC-V shovel."
