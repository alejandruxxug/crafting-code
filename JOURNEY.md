# 🐈 How this got made

This started as "we have to present about compilers" and ended as a Minecraft video, a published open-source animation tool, and four demos that had to be debugged before they'd tell the truth.

Writing it down because the detours were the interesting part.

---

## 1. The premise

Languages & Compilers, paired with Data Structures. Everyone else was going to make slides about the JVM.

The idea was to record the presentation **inside Minecraft** — and the reason isn't that Minecraft is fun. It's that Minecraft is a Java program, running as bytecode, on a virtual machine, *right now, while you watch the video about bytecode running on virtual machines*. The presentation runs inside its own subject matter. The cold open says this out loud and the last line calls back to it.

Once that was the frame, the metaphors came almost for free:

| Concept | Minecraft |
|---|---|
| Bytecode | A shulker box of pre-cut, standardized blocks |
| The JVM | The factory that opens any shulker box, in any world |
| JIT compiler | The villager who's built this wall 10,000 times and makes a Structure Block stamp |
| Garbage collector | The Allay that vacuums up chests nobody references anymore |
| LLVM IR | The universal ingot — every ore smelts into it |
| WebAssembly | An ender chest — opens in any world, instantly |

Full map in [SCRIPT.md](SCRIPT.md).

---

## 2. The rule that made it work

> **Humans never touch code. Cats never touch metaphors.**

Two Minecraft characters (MAJO and ALEJO) carry every metaphor. Two AI-animated cats — **NERO**, deadpan JVM engineer, and **LIMON**, hyperactive LLVM speedrunner — carry every piece of real code. When a cat appears, the screen gets a code overlay.

That constraint is doing real work. It means the abstract explanation never gets muddied by syntax, and the code never gets hand-waved. It's also the joke.

---

## 3. The cats needed to exist

Pixel-art sprite sheets, generated with an image model. Two things learned the hard way:

- **Two passes, never one.** A pose sheet first, then a talking sheet with the body frozen and only the mouth changing. Asking for both in one image gets you neither.
- **One cat per sheet.** Put both in one prompt and the model blends them into a single cat that is somehow both.

Then the actual problem: **a sprite sheet is not an animation.** Something had to drive the mouth from the recorded audio.

---

## 4. So the tool got built → CatSync

**🔗 [github.com/alejandruxxug/Catsync](https://github.com/alejandruxxug/Catsync) · [live, no install](https://alejandruxxug.github.io/Catsync/)**

Sprite sheet in, voice recording in, lip-synced animation out. One HTML file, no dependencies, no build step, no server — works with the wifi off. MIT licensed.

The decision that mattered was made **before a single line was written**: it was going to be a Python CLI, and it became a browser app instead. Same program technically. Completely different tool in practice — you can *see* it working instead of running it and hoping. The live preview is the reason it's usable at all.

What it does:

- Slicing editor — origin, cell size, gutter, dragged directly on the sheet, with auto-detect that reads the grid off the image
- Onion-skin align, because diffusion models can't hold a sprite pixel-identical across cells
- Record straight into the page, mic to pipeline
- PNG sequence export with exact alpha (hand-written ZIP), plus WebM for quick checks
- **Live mode** — mic in, cat animating in realtime in a pop-out window that OBS takes as a window capture

### The bugs are the education

Five things broke. **Four of them broke silently** — nothing crashed, the output just quietly got worse:

1. **`MediaRecorder` writes a live-stream container with no length in its header.** This caused two completely different symptoms weeks apart: WebM exports came out seconds short, and later an `<audio>` element reported `Infinity` duration and refused to seek. Same hole, twice.
2. **Chroma despill went dark instead of clean.** Textbook despill clamps the key color's dominant channels — for magenta that's R *and* B, which collapses toward the lone green channel and paints a dark halo. Fixed by desaturating toward each pixel's own mean, which holds luminance exactly.
3. **A "harmless" optimization that silently lied.** Auto-align sampled every second pixel to go 4× faster. Stride 2 aliases away odd-numbered shifts — 2 of 3 test cells came back off by one, under a comment claiming "same answer." Speed that changes the answer isn't speed.
4. **The threshold was a cliff, not a slider.** The demo used digital silence, so the slider appeared to do nothing. Add realistic room tone and 18 → 20 moved mouth-closed from 3% to 40%. It's now derived from each file's own noise floor.
5. **Browsers enable auto gain control by default** — and loud-against-quiet *is* the entire lip-sync signal. Left on, it erases the thing being measured and you'd never know why your takes read worse than a dragged-in file.

The throughline: develop a nose for the failure mode where nothing goes wrong, it just gets worse.

---

## 5. Then the demos had to be real

The script had four code overlays. The plan was to run them, screenshot the output, done.

Three of the four fought back.

### The JIT demo measured nothing

The obvious way to show the JVM compiling a hot method is one call with a huge loop, warm up, call again. **It reports 1.0x.** No speedup at all.

The cause is **on-stack replacement**: the JVM counts loop back-edges, not just method calls, and it can swap in a compiled version *while the method is still on the stack*. Fifty million iterations means the loop goes hot during the very first call — the "cold" measurement was already native code.

The fix is the opposite shape: a **small** method called **many** times, so the invocation counter is what fires. That gives a real ~8x. Full writeup in the [README](README.md#why-the-obvious-version-of-this-demo-doesnt-work).

Nearly filmed the broken one.

### Apple's clang can't do WebAssembly

macOS ships a clang that looks complete and has the wasm32 target compiled out. No flag fixes it. Needed a full `brew install llvm lld` — two formulae, because `wasm-ld` lives in the linker package.

There's also a zero-install fallback in `03-wasm/no-toolchain.mjs`: the same module hand-assembled as 41 raw bytes, which runs anywhere Node does.

### The compiler wouldn't say `%sum`

The script's LLVM overlay uses `%sum`, and Limon says "`%sum`" out loud in a take that's already recorded. Real `clang` names the SSA value `%add` — after the *operation*, not the variable — and no source-level rename changes that once mem2reg runs.

Rather than fake the overlay, the repo ships a hand-written [`02-llvm/add.ll`](02-llvm/add.ll) that genuinely says `%sum`. LLVM IR is a real language with a real assembler, and `run.sh` proves it by lowering that exact file to three architectures.

### The one that just worked

`javac` → `javap -c`. Four instructions, exactly as scripted. It does print a constructor you never wrote, which the video crops.

---

## 6. Where it landed

```
Minecraft footage  ─┐
                    ├─→  the video
CatSync animation  ─┤
                    │
terminal captures  ─┘   ← this repo
```

Not one number on screen is invented. The JIT genuinely changes its mind on camera, one `add.ll` really does become three different machines, and the sunset the characters are standing in really is bytecode on a stack machine.

Which was the whole idea, three weeks earlier.

🐈 🐈‍⬛
