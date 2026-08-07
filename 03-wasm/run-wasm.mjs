// Loads a .wasm file, reports its size, calls the exported add().
// Usage: node run-wasm.mjs add.wasm
import { readFile } from "node:fs/promises";

const path = process.argv[2] ?? "add.wasm";
const bytes = await readFile(path);

console.log(`${path} is ${bytes.length} bytes`);

const { instance } = await WebAssembly.instantiate(bytes);
console.log("add(2, 40) =", instance.exports.add(2, 40));
