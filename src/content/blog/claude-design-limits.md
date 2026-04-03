---
title: "Claude Is Great Until It Isn't"
date: 2026-04-03
description: "Using Claude Opus 4.6 for design work is incredible — until you hit 40% context and it forgets everything you just said."
tags: ["ai", "workflow", "ai-assisted"]
revisions: 0
---

> **Revision counter:** I asked Claude to fix this post **0 times** before it got the details right. Peak AI experience.

![short term memory loss](https://media3.giphy.com/media/qZgHBlenHa1zKqy6Zn/giphy.gif?cid=9b38fe9142ouusrtt3vflo1l4wax7cy7cheumi017ebfkk4s&ep=v1_gifs_search&rid=giphy.gif&ct=g)

I've been using Claude — the big boy, Opus 4.6 with 1 million token thinking — for design work. And honestly? It's impressive. Until it isn't.

## The First 40%

When context is fresh, Claude is locked in. It remembers the architecture, understands the constraints, connects the dots between what you said ten messages ago and what you're asking now. It feels like pair programming with someone who actually read the docs.

This is the golden zone. Enjoy it while it lasts.

## After 40%

Then you cross some invisible threshold and things get weird. It starts forgetting decisions we already made. It suggests things we explicitly ruled out three messages ago. You find yourself repeating context like you're talking to someone who just walked into the room mid-conversation.

Short term memory loss is real. I'll be deep into a design discussion and Claude will respond like we're meeting for the first time. Sir, we've been at this for an hour.

## The Caveats It Misses

The other thing — Claude doesn't catch deployment caveats. You can design two services that work perfectly in isolation, and Claude will happily help you build both without mentioning that deploying them in different environments is going to cause problems.

It doesn't think about the stuff between the systems. The glue. The "wait, this assumes they're on the same network" type issues that any engineer with scars would flag immediately. Claude has no scars. It has vibes.

## Still Using It Though

Look, despite all this, Claude is still the best tool I've got for design work. The trick is knowing when to start a fresh context instead of pushing through. Treat the 40% mark like a save point — summarize where you are, start a new session, paste the summary, keep going.

It's not a replacement for engineering judgment. It's a force multiplier for it. Big difference.
