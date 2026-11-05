---
title: "I Made Local Models Build a Shinkansen Before Trusting Them"
date: 2026-11-05
description: "Tokens per second is a vanity metric. So I built a harness that makes each local model write a Three.js scene, renders it in headless Chromium, and checks whether Mount Fuji is actually on screen."
tags: ["ai", "local-llm", "benchmarks", "homelab", "ai-assisted"]
revisions: 1
---

> **Revision counter:** I asked Bud to fix this post **1 time** before it got the details right. Peak AI experience.

## The Problem With Tokens Per Second

Every local LLM post I read is a scoreboard of `tok/s` and a screenshot of a progress bar. That tells me how fast the model types. It does not tell me whether the model can produce something that runs.

A model that streams 60 tok/s and writes broken WebGL is slower than a model that writes working WebGL at 30 tok/s. Slower, in wall-clock terms, because I then spend my evening debugging its `NaN` camera matrix.

So instead of a token counter, I gave the models a homework assignment: build a website.

## The Rig

One machine: an **Apple M2 Ultra with 64 GB** of unified memory. Two Apple Silicon Macs sit on my desk and an **exo** cluster is configured between them, but these runs never touched it — exo was idle. Everything below ran locally through **Strata** (`0.1.56-macos-arm64-metal`), which served the model over an OpenAI-compatible endpoint on localhost.

The relevant flags on the engine:

```
--serve --pack iq3_xxs
--native  Qwen3.8-Flash-Next-GSQ-RCO-IQ3_XXS-00001-of-00002.gguf
--ple-gguf ...-00002-of-00002.gguf
--mmap-experts --expert-cache 64 --vram-reserve-mib 1536
--max-context 131072
--draft dflash2 --draft-model ...-dflash2.q4_0-selq4.pack --spec 6 --draft-conf 0.8
```

Which is how a 75.8 GB model fits in 64 GB: the experts stay memory-mapped on disk and only a slice gets pulled into memory, while `spec 6` speculative decoding with a small `dflash2` draft model does the speed work.

The two models being compared:

- **IQ3_XXS** — ISTA-DASLab's Qwen3.8-Flash-Next-GSQ-RCO, ~75.8 GB on disk
- **Q2_0** — same architecture, one quant step lower, ~66.4 GB

Same weights, different compression, same engine, same flags. The question is what you lose when you shrink 75 GB to 66 GB.

## The Assignment

One prompt, one file:

> Write a single self-contained HTML page using Three.js: a Shinkansen in sakura season with Mount Fuji off to the side. It must animate, must set a `render-ok` flag, and must expose the scene and camera on `window` so a test harness can inspect them.

Same prompt for every run, temperature 0.0, same 16k token budget. The generated page is allowed exactly one network call: the Three.js CDN.

## The Harness

The script lives at `~/.hermes/scripts/model_bench.py` and does five things:

1. **Generate** — stream the model's answer. This is where the first trap lives: reasoning models stream their thinking in `delta.reasoning_content`, not `delta.content`. If you only read `content`, you get an empty file and a very confident-looking log.
2. **Extract and syntax check** — strip code fences, wrap in a doctype if the model forgot one, run a JS parse.
3. **Render** — headless Chromium loads the page and takes a screenshot. Two gotchas here: `--disable-gpu` produces a perfectly black frame that looks like a model failure but is really a WebGL failure, and without `--virtual-time-budget=8000` the screenshot is taken before the animation loop has drawn anything.
4. **Probe the scene** — inject a script that counts meshes and how many are inside the camera frustum, and lists named objects. A page can define `fujiMountain` and never point the camera at it. Without this step, "the model produced a scene" and "the model produced a scene you can see" look identical.
5. **Score deterministically** — train present, sakura present, Fuji present, animation present, camera present, render flag present, an actual render call, objects in view. Plus a stdlib PNG decode: fewer than 50 distinct colors means the frame is blank, so a black screenshot can't fake a pass.

## The Numbers

```
                     IQ3_XXS    Q2_0     Q2_0 (no thinking)
score                  100        100        80
meshes / in view      148/130    226/215     —
wall clock            412.8s     233.9s      41.2s
time to first token    9.3s       5.7s       —
decode tok/s           35.3       58.7       67.5
completion tokens     14,591     13,719      2,784
reasoning chars       44,122     44,003          0
draft accepted        7,498      7,732      1,789
                        /8,593     /8,628     /2,125
distinct colors       29,389      6,629     36,131
mean luminance         111.4       82.0      106.8
```

![IQ3_XXS render](/images/bench-iq3-xxs.png)
*IQ3_XXS: 148 meshes, 130 of them in frame, 214 lines of code.*

![Q2_0 render](/images/bench-q2-0.png)
*Q2_0: 226 meshes, 215 in frame, 122 lines of code.*

## What The Numbers Say

**The cheaper quant is faster and more coherent, not less.** Q2_0 finished in 234 seconds instead of 413 and put 215 objects in the camera's view against IQ3's 130. The lower-quant model wrote less code and put more of it on screen. IQ3_XXS spent 412 seconds writing 214 lines and framing the shot like it was scared of the composition.

**Speculative decoding is carrying the whole operation.** Draft acceptance was 87% and 90%. Without it, decode speed collapses and none of these runs finish inside a coffee break.

**Prefill caching is the difference between instant and painful.** On the IQ3 run, Strata reused 284 of 289 prompt tokens and spent 0.66 seconds on prefill. The Q2_0 run started cold, reusing nothing, and paid 18.8 seconds to prefill the same 289 tokens. Same engine, same prompt, 28x difference. Warm the cache and the model feels different.

**The reasoning tax is enormous.** Both runs generated about 44,000 characters of thinking to produce 5,000–7,400 characters of code. That's 6–9 characters of internal monologue for every character of code. Killing thinking on Q2_0 dropped wall time from 234 seconds to 41 — but the score fell to 80, because the model skipped exposing the scene globals the probe needs. Thinking is expensive and it was doing real work.

**Both frames are technically perfect and aesthetically a PS1 demo.** IQ3 produced 29,389 distinct colors at mean luminance 111. Q2_0 produced 6,629 at luminance 82. The "better" score came with the flatter picture. The deterministic harness tells me the code is correct; it does not tell me the render is beautiful. Those are two different questions and only one of them automates.

## Two Things Broke On The Way

**Context compression flat-out failed.** The summariser model had a 48,000 token window and compression required at least 64,000. It threw a `ValueError`, and separately hit a 600-second ceiling because the summariser burned 18,000 thinking tokens before summarising anything. Fix: raise the session to a 131,072 token window and force `reasoning_effort: none` for auxiliary calls. The compressing model does not need to reflect on your conversation. It needs to be fast.

**KV cache parking refused to start.** Strata logged `skip parking (physical RAM admission; need 1634 MiB plus 2560 MiB floor, 4132 MiB available)` — it declined to park the cache because it could not guarantee the memory. Once it sized the conversation cache at 8192 MiB, parking resumed and consecutive turns reused 65k+ tokens in under a second. Remaining cold reads came from parallel jobs evicting the cache, which is the tax for running a benchmark while the agent is also working.

## Verdict

Quantization is not a quality dial. Going from IQ3 to Q2 moved structure up and pixels down, and the run got 43% faster. That tradeoff is only visible if the test produces an artifact that can be probed — a token counter would have shown me 35 vs 59 tok/s and told me nothing about which model actually built the thing.

I know which model I'm keeping loaded. I do not know which one would make Mount Fuji look good, and I'm not sure the model is the one responsible.
