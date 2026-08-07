#!/usr/bin/env bash
# Video 7:05 — LLVM lowers to .wasm instead of to one CPU.
set -euo pipefail
cd "$(dirname "$0")"

CLANG="/opt/homebrew/opt/llvm/bin/clang"
WASMLD="/opt/homebrew/opt/lld/bin/wasm-ld"

if [ ! -x "$CLANG" ] || [ ! -x "$WASMLD" ]; then
  echo "!! Apple's clang has no wasm32 target. You need Homebrew's LLVM:"
  echo "     brew install llvm lld"
  echo
  echo "   Or skip the toolchain entirely — same result, nothing to install:"
  echo "     node no-toolchain.mjs"
  exit 1
fi

echo "==> C -> .wasm, through LLVM"
"$CLANG" --target=wasm32 -nostdlib -O2 \
  -fuse-ld="$WASMLD" \
  -Wl,--no-entry -Wl,--export=add -Wl,--strip-all \
  -o add.wasm add.c

echo
echo "==> node run-wasm.mjs add.wasm"
node run-wasm.mjs add.wasm

echo
echo "==> the text format this corresponds to (add.wat):"
sed 's/^/    /' add.wat

echo
echo "==> and the same module hand-assembled, for comparison:"
node no-toolchain.mjs | sed 's/^/    /'
