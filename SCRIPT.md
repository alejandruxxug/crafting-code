# 🧱 CRAFTING CODE — Bytecode, the JVM, LLVM & WebAssembly

A Minecraft-recorded presentation script for Languages & Compilers + DSA. Target runtime: **9:55**. Tags: #compilers #jvm #llvm #wasm #presentation

Every code overlay in this script is a runnable demo in this repo — see [README.md](README.md).
How the whole thing got built: [JOURNEY.md](JOURNEY.md).

---

## The cast

| Who             | Skin / Form                                     | Role                                | Personality                                         |
| --------------- | ----------------------------------------------- | ----------------------------------- | --------------------------------------------------- |
| **MAJO** (girl) | Minecraft default *Alex* skin                   | Core concepts, the "why"            | Confident, drives the pace, does the transitions    |
| **ALEJO** (boy) | Minecraft default *Steve* skin                  | Core concepts, the "wait, but why?" | Curious, asks the question the teacher is thinking  |
| **🐈 NERO**     | AI-animated grey & white white, tiny sunglasses | **JVM & bytecode engineer**         | Deadpan senior dev. Speaks slowly. Has seen things. |
| **🐈‍⬛ LIMON**  | AI-animated grey siamese, hoodie                | **LLVM & WebAssembly engineer**     | Hyperactive speedrunner. Talks fast. Zero chill.    |
|                 |                                                 |                                     |                                                     |

**Rule that makes this work:** humans never touch code. Cats never touch metaphors. When a cat appears, the screen gets a code overlay. That contrast *is* the joke and the structure.

---

## The metaphor map (memorize this, it's the spine of the video)

| Real concept               | Minecraft object                                                                          |
| -------------------------- | ----------------------------------------------------------------------------------------- |
| Source code                | Book & Quill — your written build plan                                                    |
| Compiler                   | Furnace / crafting table (raw ore → ingot)                                                |
| Native machine code        | Blocks actually placed, in **one specific world**                                         |
| Interpretation             | Reading the book and placing blocks by hand, live                                         |
| Compilation                | **Structure Block** — save once, paste the whole build instantly                          |
| Bytecode (`.class`)        | A **shulker box** of pre-cut, standardized blocks                                         |
| JVM                        | The factory that opens any shulker box, in any world                                      |
| Class loader               | The hopper feeding the factory                                                            |
| Bytecode verifier          | Anti-cheat scanning the box for TNT                                                       |
| Interpreter                | A villager placing blocks one at a time                                                   |
| JIT compiler               | The villager noticing "I've built this wall 10,000 times" → makes a Structure Block stamp |
| Heap / Stack / Method area | Chest room / your hotbar / the enchanting library                                         |
| Garbage collector          | The Allay that vacuums up chests nobody references anymore                                |
| LLVM IR                    | **The universal ingot** — every ore smelts into it                                        |
| LLVM middle end            | The grindstone + anvil (strip junk, merge rooms)                                          |
| LLVM back end              | Ingot → the right tool for *this* world (x86 pickaxe, ARM axe, RISC-V shovel)             |
| WebAssembly                | An **ender chest** — opens in any world, instantly                                        |
| Wasm sandbox               | A barrier-block cage: no reach outside unless you `/give` permission                      |

---

# THE SCRIPT

> Format: `[TIME] — SHOT / TRANSITION` then dialogue. Overlays marked **[OVERLAY]**. Command-block cues marked **[CB#]** → see appendix.

---

### 0:00 — COLD OPEN // DONE
*Shot: F5 third-person, MAJO and ALEJO standing on a grass hill at sunrise.*

**MAJO:** Okay. Everything you can see right now — the sun, the grass, the creeper about to ruin my day —

*(A creeper hisses offscreen. Small explosion. MAJO doesn't flinch.)*

**MAJO:** — is Java. Running as *bytecode*. On a *virtual machine*. Right now.

**ALEJO:** So the game we're presenting in… is literally the thing we're presenting about?

**MAJO:** The game we're presenting in is literally the thing we're presenting about.

**[CB1 — `/title` slams in: "CRAFTING CODE" / subtitle: "how source becomes something a CPU can run"]**
*Transition: **mine straight down** through the title, fall into a lit stone room.*

---

### 0:35 — THE ROADMAP //DONE
*Shot: underground room, 4 item frames on the wall: Book, Shulker Box, Ingot, Ender Chest.*

**ALEJO:** Four things. Why four?

**MAJO:** Because they all answer one question: *how does something you typed become something a machine actually runs* — without rewriting it for every computer on Earth.

**MAJO:** Compilation versus interpretation is the foundation. Bytecode is the format. The JVM runs it. LLVM builds it. WebAssembly ships it everywhere.

**ALEJO:** And the cats?

**MAJO:** The cats show the actual code. We stay in blocks. They go in the trenches.

---

### 1:05 — PART 1: COMPILATION vs INTERPRETATION //DONE
*Transition: **nether portal wipe** — walk into portal, cut to a flat build arena.*

**[OVERLAY: big text — "1. COMPILE vs INTERPRET"]**

**ALEJO:** *(holding a Book & Quill)* So I have a build plan. A house. How do I get a house?

**MAJO:** Two ways. Way one — **interpretation**.

*Shot: ALEJO reads the book out loud, places one block, reads, places one block. Painfully slow.*

**MAJO:** He reads a line, he does the line. Reads a line, does the line. Nothing is prepared in advance. He starts *instantly*, but he's slow forever — and he re-reads the whole book every single time he builds this house.

**ALEJO:** *(still placing blocks)* I regret this.

**MAJO:** And here's the killer — *(ALEJO places a block, the structure collapses)* — he only found that mistake on line 400. Because he never read line 400 until now.

**MAJO:** Way two — **compilation**.

*Shot: MAJO places a **Structure Block**, saves the finished house, walks 20 blocks away, pastes it. Instant full house.*

**[CB2 — structure block paste + `/particle` burst]**

**MAJO:** One translation pass, up front. Then it just… runs. Fast, every time. It checked the whole plan before building, so it caught the error *before* anything got placed.

**ALEJO:** So compiling is just better?

**MAJO:** Cost. You waited for the build step. And that saved structure only fits *this* world — different world, different size, you're re-saving it. That's native code: tied to one CPU, one OS.

**[OVERLAY: clean comparison table — Speed / Startup / Portability / Error detection]**

**MAJO:** Fast to start and portable, or fast to run and specific. Pick.

**ALEJO:** …Can't we have both?

**MAJO:** *(grins)* That's the entire rest of the video.

*Transition: **ender pearl whip-pan** — throw pearl at camera, hard cut.*

---

### 2:40 — PART 2: BYTECODE //DONE
*Shot: MAJO holding a purple shulker box.*

**[OVERLAY: "2. BYTECODE"]**

**MAJO:** The compromise is: don't compile all the way down. Stop halfway.

**MAJO:** Your source is a messy handwritten book. Native code is blocks glued to one world. **Bytecode is the shulker box** — pre-cut, standardized, stackable pieces. Not source anymore. Not machine code yet.

**MAJO:** Portable — any world with the right factory can open it. Compact — already chopped into simple instructions, nothing to re-parse. And *safe* — you can X-ray the box for TNT before you open it. You can't do that with raw native code.

**ALEJO:** So who makes the box?

**MAJO:** `javac`. Your `.java` goes in, a `.class` comes out. Nero — you're up.

*Transition: cat door / camera dives into the shulker box, screen goes dark.*

---

### 3:10 — 🐈 NERO'S FIRST SEGMENT // NEED VIDEO
*Shot: AI-animated NERO at a desk. Full-screen code overlay beside him.*

> **🎬 DEMO 1 — repo `01-bytecode/`, run `./run.sh`**
> Screen-record the terminal, drop it in beside Nero. Full instructions: [README.md](README.md)

**NERO:** Hello. I am Nero. I read class files for fun, which is why I live alone.

**[OVERLAY A — `Add.java` on screen]**
```java
public class Add {
    public static int add(int a, int b) {
        return a + b;
    }
}
```

**NERO:** Three lines. Now we dissamble it using javap -c.

**[OVERLAY B — terminal running `javac Add.java` then `javap -c Add`]**

⚠️ **Crop the constructor.** Real `javap` also prints `public Add();` with `aload_0 / invokespecial / return` above the method — that's the constructor `javac` writes for you. Nero's next line says "**Four** instructions," so the frame must show only these four. Crop in the edit, or run `javap -c Add | sed -n '/add(int, int)/,$p'` before recording.

```
  public static int add(int, int);
    Code:
         0: iload_0
         1: iload_1
         2: iadd
         3: ireturn
```

**NERO:** Four instructions. `iload_0` pushes `a`. `iload_1` pushes `b`. `iadd` pops two, pushes the sum. `ireturn` returns it.

**NERO:** Notice what is missing. No registers. No `x86`. No `ARM`. The JVM is a **stack machine** — every operation is push and pop, `O(1)` each. That is your Data Structures class showing up in the actual runtime of a real language.

**[OVERLAY C — `javap -v Add`, the constant pool table]**
*Cut to this on the words "constant pool." He says "indexed array" — the numbers down the left are the whole point. `run.sh` prints this as its third step.*

```
Constant pool:
   #1 = Methodref          #2.#3          // java/lang/Object."<init>":()V
   #2 = Class              #4             // java/lang/Object
   #3 = NameAndType        #5:#6          // "<init>":()V
   #4 = Utf8               java/lang/Object
   ...
  #11 = Utf8               add
  #12 = Utf8               (II)I
```

**NERO:** And `javap` itself is a small algorithm: parse the **constant pool** — an indexed array, so lookups are `O(1)` — then linear-scan the instruction stream once. `O(n)` over the bytecode length. That is all a disassembler is.

*Transition: NERO pushes sunglasses up, screen wipes.*

---

### 3:50 — PART 3: THE JVM //DONE
*Transition: **elytra fly-through** — MAJO & ALEJO fly into a giant redstone factory build.*

**[OVERLAY: "3. THE JAVA VIRTUAL MACHINE"]**

**MAJO:** The shulker box is useless without the factory. The factory is the **JVM**.

*Shot: walking the factory floor, each station labeled with a floating armor stand.* **[CB3 — armor stand labels]**

**MAJO:** Station one — the **class loader**. The hopper. Finds your `.class`, pulls it into memory.

**MAJO:** Station two — the **verifier**. Anti-cheat. Is this bytecode well-formed? Is it trying something illegal? If yes, it never runs.

**MAJO:** Station three — the **interpreter**. A slave, placing your instructions one at a time. Sound familiar?

**ALEJO:** That's the slow way from Part 1!

**MAJO:** It is. Watch what happens when you do it ten thousand times.

*Shot: the villager builds the same wall repeatedly. The path under it turns from stone → magma block, glowing.* **[CB4 — hot path]**

**MAJO:** The JVM is *counting*. Method call counts, in a hash map. When one gets hot —

**[CB5 — `/title` flash: "JIT"]**

**MAJO:** — it stops interpreting it and **compiles that method to native code, mid-flight**, made at runtime, for the parts that actually matter.

**ALEJO:** So it starts fast like an interpreter, then gets fast like a compiler.

**MAJO:** That's the whole trick. It's not compiled *or* interpreted. It's a spectrum, and the JVM slides along it while your program is running.

**MAJO:** Station four — **runtime data areas**. The chest room is the **heap** — objects. Your hotbar is the **stack** — the current method's locals, push and pop. The enchanting library is the **method area** — class definitions.

**MAJO:** Station five — the **garbage collector**.

*Shot: an Allay flies through, collecting items nobody is holding.* **[CB6 — `/kill @e[type=item]` + particles]**

**MAJO:** Nobody references that chest anymore, so it's gone. And *how* does it know? It walks a **graph** — starts at the GC roots, traverses every reachable object, marks them. Anything it never reached, it sweeps.

**ALEJO:** That's a graph traversal. That's BFS.

**MAJO:** That's your DSA class managing your memory, quietly, forever.

**MAJO:** And the payoff: same `.class` file. Windows, Linux, macOS. Any world with a factory. *Write once, run anywhere.*

*Transition: **TNT cut** — light TNT, explosion covers the screen, hard cut.*

---

### 5:45 — PART 4: LLVM //NEED VIDEO
*Shot: LIMON already talking before the scene loads.*

**[OVERLAY: "4. LLVM"]**

**LIMON:** HI. Different problem. Say you have C, C++, Rust, and Swift, and you want them on x86, ARM, and RISC-V. How many compiler back ends do you build?

**ALEJO:** Four times three… twelve?

**LIMON:** Twelve. And you'd have to write "make loops faster" *twelve times.* Absolutely not.

*Shot: four different ores in four furnaces, all outputting the **same ingot**.* **[CB7 — hopper/minecart pipeline]**

**LIMON:** **Front end**: every language smelts into the same ingot — **LLVM IR**. Clang does it for C and C++. `rustc` does it for Rust.

> **🎬 DEMO 2 — repo `02-llvm/`, run `./run.sh`**
> Three parts, one per Limon line below. Full instructions: [README.md](README.md)

**[OVERLAY D — `add.ll` on screen]**
```llvm
define i32 @add(i32 %a, i32 %b) {
  %sum = add nsw i32 %a, %b
  ret i32 %sum
}
```

*This is shipped in the repo as a real hand-written `add.ll`, not a mockup — LLVM IR is a language you can write and assemble directly, and `run.sh` proves it by lowering this exact file. Keep the overlay verbatim: Limon says "`%sum`" out loud and that take is locked.*

**LIMON:** Same function Nero showed you. But look — `%a`, `%b`, `%sum`. **Named registers, infinite of them, each assigned exactly once.** LLVM IR is a *register machine*; the JVM is a *stack machine*. Different data structure, different job.

**[OVERLAY E — split screen: `clang -O0` vs `clang -O1`]**
*Nine instructions on the left, two on the right. Cut to this on the word "grindstone" — it's the middle end doing its job on camera, and it's the strongest new visual in Limon's section.*

**LIMON:** **Middle end**: the grindstone. Dead code stripped, functions inlined, loops simplified — all on the IR, before anyone knows what CPU we're targeting. Write the optimization once, every language gets it free.

**[OVERLAY F — the same `add.ll` lowered three times, `llc -march=` arm64 / x86-64 / riscv64]**

```
arm64     →   add   w0, w0, w1        /  ret
x86-64    →   leal  (%rdi,%rsi), %eax /  retq
riscv64   →   addw  a0, a0, a1        /  ret
```

*Three columns of native assembly, visibly different, from one identical source file — and they line up exactly with the three tools he names. Hold it through the whole "pickaxe / axe / shovel" beat. Best new visual in the video.*

**LIMON:** **Back end**: ingot → the right tool for the right world. x86 pickaxe. ARM axe. RISC-V shovel.

**ALEJO:** So it's the JVM but backwards?

**LIMON:** It's the JVM's *opposite*. LLVM IR is **never executed**. Nothing runs it. It exists to be optimized and then lowered to native code, ahead of time. Clang, Rust, Swift, Julia — all the same pipeline.

*Transition: **minecart down a rail tunnel**, sparks, cut.*

---

### 7:05 — PART 5: WEBASSEMBLY // NEED VIDEO
*Shot: LIMON standing on an ender chest inside a glass-and-barrier-block cage.* **[CB8 — barrier cage + particle outline]**

**[OVERLAY: "5. WEBASSEMBLY"]**

**LIMON:** Last one. Take LLVM's output, but don't lower it to one CPU. Lower it to a **`.wasm` binary** instead.

**LIMON:** Ender chest. Same chest, any world, opens instantly. Browser, server, edge, IoT — anything with a Wasm runtime.

> **🎬 DEMO 3 — repo `03-wasm/`, run `./run.sh`**
> Compiles `add.c` to a real `.wasm` through LLVM, then runs it. Full instructions: [README.md](README.md)

**[OVERLAY G — `add.wat` on screen]**
```wat
(func $add (param i32 i32) (result i32)
  local.get 0
  local.get 1
  i32.add)
```

**NERO:** *(deadpan, walking into frame)* …That's my bytecode.

**LIMON:** It's a **stack machine**, yeah. Push, push, add. Same idea as the JVM, twenty-five years later, tuned for the web.

**NERO:** I'm in a museum.

**[OVERLAY H — terminal: the module's byte count, then `add(2, 40) = 42`]**
*Land this on "compact binary format." The whole working module is a **41-byte** file, running in the same engine a browser uses. Put the number big — it proves the claim instead of asserting it, and it's the cheapest credibility in the video.*

**LIMON:** *(ignoring him)* Compact binary format — parses fast, runs at near-native speed. Language-agnostic: C, C++, Rust, Go all compile to it, usually **through LLVM**. And the cage —

*Shot: LIMON tries to walk out. Bonks the barrier.*

**LIMON:** — the **sandbox**. No filesystem, no memory outside its own, no host access unless it's explicitly granted. That's why Cloudflare and Fastly run *strangers' code* on their servers and sleep fine.

**MAJO:** And once it's loaded, the browser either interprets it or JIT-compiles it.

**ALEJO:** …which is the exact trade-off from Part 1.

**MAJO:** It's always the trade-off from Part 1.

*Transition: **sleep in bed** → screen fades → wake up at the demo desk.*

---

### 8:20 — LIVE DEMO // DONE //NEED VIDEO //JUST EDIT
*Shot: split screen — Minecraft on one side, a real terminal overlay on the other.*

> **🎬 DEMO 4 — repo `04-jit/`, run `./run.sh`**
> ⚠️ **The old code in this section produced a 1.0x speedup — no effect at all.** It's been replaced below with the version that gives a real ~8x. Why the first one failed (on-stack replacement) is written up in [README.md](README.md#why-the-obvious-version-of-this-demo-doesnt-work).

**NERO:** Real machine. Real terminal. Watch.

**[OVERLAY I — terminal, callback to the 3:10 files]**
```bash
javac Add.java   # source  →  bytecode
javap -c Add     # look inside the shulker box
```

*(Terminal shows the `iload_0 / iload_1 / iadd / ireturn` output. Use `Add`, not `Demo` — `Demo.java` below has three methods and `javap` would dump all of them.)*

**NERO:** Told you. Now the JIT.

**[OVERLAY J — `Demo.java`, the timing harness]**
```java
static long sum(int n) {                // small body, called MANY times
    long s = 0;
    for (int i = 0; i < n; i++) s += i;
    return s;
}

long cold = timeBatch(1_000, 1_000);                    // still interpreted
for (int i = 0; i < 200_000; i++) sink += sum(1_000);   // warm it up
long hot  = timeBatch(1_000, 1_000);                    // now JIT-compiled
```

**[OVERLAY K — the numbers, held on screen]**
```
cold (interpreted) :  1,756,500 ns
hot  (JIT native)  :    230,375 ns
speedup            : 7.6x
```

**NERO:** Identical bytecode. Identical input. The second one is *dramatically* faster — because between the two calls, the JVM decided this method was worth compiling and swapped it out underneath us.

**[OVERLAY L — `java -XX:+PrintCompilation Demo | grep Demo::sum`]**
*Optional but it's the best twelve seconds available. The `3` and `4` column is tier 3 (C1) → tier 4 (C2), and `made not entrant` is the JVM throwing away its own earlier compile. Cut to it on "changed its mind" — that's the machine changing its mind in its own words. `run.sh` prints it as the last step.*

**NERO:** Nothing about your program changed. The machine running it changed its mind.

*Shot: MAJO and ALEJO staring at the numbers.*

**ALEJO:** That's kind of terrifying.

**NERO:** That's Tuesday.

---

### 9:25 — RECAP & OUTRO
*Shot: all four on the hill from the cold open. Sunset.*

**[OVERLAY: the summary table — hold on screen for the full recap]**

| | **JVM** | **LLVM IR** | **WebAssembly** |
|---|---|---|---|
| **Purpose** | Portable execution | Shared optimization + codegen | Portable, fast, sandboxed execution |
| **Model** | Interpreted, then JIT | AOT → native, never executed | Interpreted or JIT |
| **Machine type** | Stack | Register (SSA) | Stack |
| **Source** | Java, Kotlin, Scala | C, C++, Rust, Swift | C/C++, Rust, Go |
| **Runs in** | The JVM | Nowhere — it's lowered | Browser, server, edge, IoT |

**MAJO:** Source code almost never touches a CPU directly. It goes through something in between — bytecode, IR, Wasm — and you pay a little overhead for portability, safety, and optimizations everyone gets to share.

**ALEJO:** And whether that middle form gets interpreted or compiled…

**MAJO:** …is a dial, not a switch. Every real system turns it both ways.

**LIMON:** Enterprise backends, Spark, Android — JVM. Clang, Rust, Swift — LLVM. Figma, Google Earth, Cloudflare Workers — Wasm.

**NERO:** And Minecraft.

*(Beat. Everyone looks at the world around them.)*

**MAJO:** And Minecraft.

**[CB9 — `/title`: "thanks for watching" + fireworks]**
*Final shot: all four mine straight down in sync. Screen cuts to black on the last block.*

**END — 9:55**

---

## 🔴 Command block appendix — what's actually easy

Ranked by effort. Everything in **GREEN** is worth doing; **RED** is not worth your week.

### 🟢 Do these — genuinely 5 minutes each

| Cue                             | Command                                                                                                               | Notes                                                                                             |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **CB1, CB5, CB9** — title cards | `/title @a title {"text":"CRAFTING CODE","color":"gold","bold":true}` then `/title @a subtitle {"text":"..."}`        | Set `/title @a times 10 60 20` first. Looks instantly professional. Use for every section header. |
| **CB3** — floating labels       | `/summon armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,CustomNameVisible:1b,CustomName:'{"text":"HEAP","color":"aqua"}'}` | Label every JVM factory station. Huge clarity win, zero redstone.                                 |
| **CB6** — garbage collection    | `/kill @e[type=item]` + `/particle happy_villager ~ ~1 ~ 3 1 3 0 60`                                                  | One button press. The Allay is just a `/summon allay`.                                            |
| **CB4** — JIT hot path          | Chain of impulse blocks: `/fill x1 y z1 x2 y z2 magma_block` along the villager's path, triggered by a button         | Stone → magma = "this path got hot." Best single visual in the video.                             |
| **CB8** — Wasm sandbox          | `/fill` a hollow cube of `barrier`, then `/particle end_rod` on the edges                                             | Invisible wall, visible outline. The bonk sells it.                                               |
| **CB2** — compile flash         | `/particle explosion ~ ~1 ~ 1 1 1 0 20` on the Structure Block paste                                                  | Sells "one instant translation."                                                                  |

### 🟡 Worth it, ~30 min

- **CB7 — the LLVM pipeline.** Four furnaces → hoppers → one minecart on powered rails carrying an item down a rail line → splits into three tracks (x86 / ARM / RISC-V). **Pure vanilla redstone, no commands.** Film it once, it carries the entire LLVM section.
- **Structure Blocks (Part 1).** Vanilla feature, no commands. Save the house, paste the house. This is the highest-value 10 minutes of setup in the whole project — it's the clearest metaphor you have.
- **Timer for the JIT race.** `/scoreboard objectives add ticks dummy` + a repeating command block adding 1 per tick, on the sidebar. Optional — the real terminal numbers are more convincing anyway.

### 🔴 Skip

- Block-by-block animated "building" via per-tick `/setblock` chains — hours of work, and a Structure Block paste communicates it better.
- Animated redstone diagrams of the GC graph traversal. Use a static image overlay instead.
- Custom entity animation for the cats *in* Minecraft. The cats are AI-animated overlays — keep them out of the game engine entirely.

---

## 📸 Overlays to prepare

### Diagrams you have to draw (6)

1. Compile vs interpret comparison table (Part 1)
2. `javac` → `.class` → JVM pipeline diagram (Part 2)
3. JVM internals diagram — loader / verifier / interpreter+JIT / data areas / GC (Part 3)
4. LLVM three-stage diagram — many front ends, one IR, many back ends (Part 4)
5. Rust → LLVM → `.wasm` → browser pipeline (Part 5)
6. The final summary table (Outro)

### Terminal captures — all four scripted and verified

Nothing to write; just record. See [README.md](README.md).

| Overlay | Video | Command |
|---|---|---|
| A, B, C | 3:10 | `./01-bytecode/run.sh` — source, bytecode, constant pool |
| D, E, F | 5:45 | `./02-llvm/run.sh` — IR, `-O0` vs `-O1`, three back ends |
| G, H | 7:05 | `./03-wasm/run.sh` — 65-byte module, `add(2, 40) = 42` |
| I, J, K, L | 8:20 | `./04-jit/run.sh` — ~8x, plus `PrintCompilation` |

---

## 🎬 Production checklist

- [ ] Build: grass hill (open/close), underground roadmap room, flat build arena, redstone factory, LLVM rail pipeline, glass sandbox cage, demo desk
- [ ] Save the Structure Block house **before** filming Part 1
- [ ] Record all Minecraft footage first, cats second — you'll know exact timings to animate to
- [x] `/gamerule doDaylightCycle false` so lighting stays consistent between takes
- [x] `/gamerule doMobSpawning false` — except the scripted cold-open creeper
- [x] F1 to hide the HUD on every scenic shot
- [x] Speak at ~150 wpm — the script is ~1,470 words, which lands at 9:50–10:00
- [x] ~~Have `Demo.java` compiled and the terminal output captured *before* recording the demo section~~ — done, all four demos are in the repo and verified
- [ ] Film the four terminal captures (`./run-all.sh` runs everything in script order)

---

## The one thing that makes this land

Your instinct in the note was the real find: **the presentation is running inside its own subject matter.** Don't bury that — you open on it and you close on it, and the whole video is framed by the fact that the sunset Alejo is standing in is bytecode on a stack machine.

Most groups will make slides about the JVM. You're going to make the JVM *demonstrate itself*. Go crush it. 🐈‍⬛


TODO record nero and alejos part including occasional majo sneak and finish editing