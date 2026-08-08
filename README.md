# 🧱 Crafting Code

Everything behind **Crafting Code: Bytecode, the JVM, LLVM & WebAssembly** — a compilers presentation recorded inside Minecraft, with the code segments narrated by two AI-animated cats.

Nothing in the video is mocked up. Every number and every listing on screen came out of the scripts in this repo, and if you run them you should get the same thing. That's the point — check our work.

Languages & Compilers · EIA University · 2026

---

## What's in here

| | |
|---|---|
| 🎬 **[SCRIPT.md](SCRIPT.md)** | The full video script — dialogue, shots, the metaphor map, and the Minecraft command-block appendix |
| 🐈 **[JOURNEY.md](JOURNEY.md)** | How this got built, including the three demos that fought back |
| 💻 **[The demos](#the-demos)** | Four runnable folders — the code from every overlay |

### The cats

They were animated with **[CatSync](https://github.com/alejandruxxug/Catsync)** — a sprite-sheet + audio → lip-synced animation tool built for this video, then cleaned up and released MIT.

One HTML file, no dependencies, no build step, no server. It [runs in your browser right now](https://alejandruxxug.github.io/Catsync/) if you want to make your own talking cat, and it works offline. The story of why it exists is in [JOURNEY.md](JOURNEY.md).

---

## TL;DR

```bash
git clone <this-repo> && cd crafting-code
./run-all.sh
```

If you only have Java installed, demos 1 and 4 work as-is. See [Requirements](#requirements).

---

## The demos

| # | Video | Folder | Shows |
|---|---|---|---|
| 1 | 3:10 | [`01-bytecode/`](01-bytecode) | `javac` → `.class`, then `javap` reading it back |
| 2 | 5:45 | [`02-llvm/`](02-llvm) | C → LLVM IR, the optimizer, then IR → three CPUs |
| 3 | 7:05 | [`03-wasm/`](03-wasm) | C → `.wasm` through LLVM, running in Node |
| 4 | 8:20 | [`04-jit/`](04-jit) | The JVM recompiling a method while the program runs |

Each folder has a `run.sh`. Run them individually or all at once with `./run-all.sh`.

Every demo compiles the same function on purpose:

```c
int add(int a, int b) { return a + b; }
```

Three lines, four ways of turning it into something a machine executes. Watching the *same* function come out as a stack machine, then a register machine, then a stack machine again is the whole argument of the video.

---

## Requirements

| Demo | Needs | Get it |
|---|---|---|
| 1, 4 | JDK 17+ | `brew install openjdk` — or it's already on your machine |
| 2 | any `clang` + `llc` | Xcode CLT covers `clang`; `llc` needs `brew install llvm` |
| 3 | Homebrew LLVM + lld | `brew install llvm lld` — **see below** |
| 3 | Node 16+ | `brew install node` |

### ⚠️ If you're on a Mac: Apple's clang cannot compile to WebAssembly

This trips people up, so it's worth being explicit. macOS ships a clang that looks complete but has the wasm32 target compiled *out*:

```
$ clang --target=wasm32 -o add.wasm add.c
error: unable to create target: 'No available targets are compatible with triple "wasm32"'
```

That is not a bug in your setup and no flag fixes it. You need a full LLVM build:

```bash
brew install llvm lld
```

Two formulae, because Homebrew ships the linker separately and `wasm-ld` lives in `lld`. `03-wasm/run.sh` calls both by absolute path (`/opt/homebrew/opt/llvm/bin/clang`, `/opt/homebrew/opt/lld/bin/wasm-ld`), so **you do not need to change your `PATH`** — Apple's clang stays your default and nothing else on your system is affected.

**Don't want a 2 GB install just to see it work?** You don't need one:

```bash
node 03-wasm/no-toolchain.mjs
```

That runs the same module, hand-assembled as 41 raw bytes. No compiler involved.

---

## What each demo prints

### 1 — Bytecode (3:10)

```bash
./01-bytecode/run.sh
```

`javac Add.java`, then `javap -c Add` to read the `.class` back:

```
  public static int add(int, int);
    Code:
         0: iload_0
         1: iload_1
         2: iadd
         3: ireturn
```

No registers, no `x86`, no `ARM` — the JVM is a **stack machine**, and every one of those is a push or a pop.

> **Note:** real `javap` also prints a `public Add();` constructor above this, with `aload_0 / invokespecial / return`. You never wrote it — `javac` did. The video crops it to keep the four instructions clean, but it's in your output and it's not an error.

The script then runs `javap -v Add` to dump the **constant pool**: fourteen numbered entries, which is the indexed array `#1`, `#7`, `#12` in the bytecode point into.

### 2 — LLVM IR (5:45)

```bash
./02-llvm/run.sh
```

Three stages, matching the three things Limon describes.

**Front end** — `clang -O0` turns `add.c` into IR. Nine instructions, full of `alloca` / `store` / `load`.

**Middle end** — `clang -O1`, same source:

```llvm
define i32 @add(i32 noundef %a, i32 noundef %b) local_unnamed_addr #0 {
entry:
  %add = add nsw i32 %b, %a
  ret i32 %add
}
```

Nine down to two. That happened *before* anything knew which CPU we were targeting — which is exactly why LLVM is built this way. Write the optimization once, every language on the front end gets it free.

**Back end** — the same hand-written [`add.ll`](02-llvm/add.ll), lowered three times:

```
llc -march=arm64      →   add   w0, w0, w1        /  ret
llc -march=x86-64     →   leal  (%rdi,%rsi), %eax /  retq
llc -march=riscv64    →   addw  a0, a0, a1        /  ret
```

One file in, three different machines out. `add.ll` is real hand-written LLVM IR, not a listing we typed for the slide — `llc` wouldn't accept it otherwise.

### 3 — WebAssembly (7:05)

```bash
./03-wasm/run.sh
```

Compiles `add.c` to an actual `.wasm` binary through LLVM, then loads it in Node:

```
add.wasm is 65 bytes
add(2, 40) = 42
```

**65 bytes** for a complete, loadable, callable module — and Node runs it on V8, the same engine as Chrome. The script also prints the hand-assembled 41-byte version, which is the theoretical floor for this module once you drop the compiler's section headers.

The `.wat` text format ([`add.wat`](03-wasm/add.wat)) is where the punchline lives:

```wat
local.get 0
local.get 1
i32.add
```

Push, push, add. That is the JVM's `iload_0 / iload_1 / iadd` from demo 1, twenty-five years later. Both are stack machines. That's not a coincidence and it's the reason the two cats argue about it.

### 4 — The JIT (8:20)

```bash
./04-jit/run.sh
```

```
cold (interpreted) :  1,756,500 ns
hot  (JIT native)  :    230,375 ns
speedup            : 7.6x
```

**Identical bytecode. Identical input.** The only difference is that 200,000 calls happened in between, and somewhere in there the JVM decided `sum` was worth compiling to native code and swapped it out mid-flight.

Expect roughly **6x–9x**. The exact number moves with your CPU and what else is running; the order of magnitude is the stable part.

Then the receipt:

```bash
java -XX:+PrintCompilation Demo 2>&1 | grep 'Demo::sum'
```

```
13    8 %     3       Demo::sum @ 4 (22 bytes)
13    9       3       Demo::sum (22 bytes)
14   10 %     4       Demo::sum @ 4 (22 bytes)
14    8 %     3       Demo::sum @ 4 (22 bytes)   made not entrant: OSR invalidation of lower level
15   11       4       Demo::sum (22 bytes)
15    9       3       Demo::sum (22 bytes)   made not entrant: not used
```

The `3` / `4` column is the tier: **3 = C1** (fast to compile, decent code), **4 = C2** (slow to compile, excellent code). You are watching the JVM promote the method, then mark its own earlier compilation `made not entrant` — throwing away work it did seconds ago because it now has something better.

#### Why the obvious version of this demo doesn't work

Worth knowing if you try to write your own, because we got this wrong first.

The natural thing is one call with a huge loop:

```java
sum(50_000_000);                                 // "cold"
for (int i = 0; i < 20; i++) sum(50_000_000);    // warm up
sum(50_000_000);                                 // "hot"
```

That measures **1.0x**. No speedup at all.

The reason is **on-stack replacement**. The JVM doesn't only count method calls — it counts loop back-edges too, and it can swap a method's compiled version in *while that method is still on the stack*. With fifty million iterations the loop goes hot during the very first call, so the "cold" run was already native. Disable OSR with `-XX:-UseOnStackReplacement` and the cold number jumps from 12 ms to 185 ms, which is what interpretation actually costs.

Twenty calls is also nowhere near enough on its own: C1 needs ~1,500 invocations and C2 ~10,000.

So the working version is the opposite shape — a **small** method called **many** times, which drives the invocation counter instead of the back-edge counter. Hence `sum(1_000)` × 200,000 in [`Demo.java`](04-jit/Demo.java).

The `sink` variable matters too: without something consuming the result, the JIT correctly deletes the entire computation as dead code and you measure an empty loop.

---

## Repo layout

```
README.md      you are here
SCRIPT.md      the full video script
JOURNEY.md     how it got made

01-bytecode/   Add.java              run.sh
02-llvm/       add.c  add.ll         run.sh
03-wasm/       add.c  add.wat        run.sh  run-wasm.mjs  no-toolchain.mjs
04-jit/        Demo.java             run.sh
run-all.sh
```

---

## Verified on

macOS 26 (Apple Silicon) · OpenJDK 25.0.2 · Apple clang 17.0.0 · Homebrew clang/llc 22.1.8 · lld 22.1.8 · Node 22

Linux should work everywhere except the hardcoded Homebrew paths in `03-wasm/run.sh` — change those two variables to wherever your distro puts `clang` and `wasm-ld`, or just run `no-toolchain.mjs`.
