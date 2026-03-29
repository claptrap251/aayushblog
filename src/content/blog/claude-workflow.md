---
title: "I'm Using AI to Write This Post About Using AI"
date: 2026-03-29
description: "How I use Claude to go from idea to published blog post in minutes. The future is already here and it's weirdly casual."
tags: ["meta", "ai", "astro", "workflow", "ai-assisted"]
---

Yes, this post was made with the help of Claude. Yes, I see the irony. Let's move on.

![The future is now](https://media4.giphy.com/media/v1.Y2lkPTZjMDliOTUyemIzem83enk5b2pvYTg2eW93eGQ5eHMxNjhhNTh5eXU1djFjbzlzdCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/KpACNEh8jXK2Q/giphy.gif)

## The Old Way

Think of a post idea. Open the editor. Write frontmatter from memory. Get the date format wrong. Write an intro. Go make coffee. Come back. Write the rest. Realize you forgot a tag. Rebuild. Push. Wait.

It worked. It was fine. But "fine" is not exactly the pitch for a tech blog in 2026.

## The New Way

I tell Claude what I want to write about and it creates the Markdown file with the right frontmatter, the right tone, and drops it into the right directory. I read it, tweak it, push it. Done.

On desktop, that's Claude Code in the terminal. On my phone, it's the Claude iOS app. I'm literally writing this post from my couch right now. Same AI, same repo access, different couch cushion.

## How the Blog Works

### The Stack

- **Astro** — static site generator. Fast, simple, Markdown-native.
- **Pure CSS** with custom properties — no Tailwind, no component library. Just `var(--accent)` and good decisions.
- **JetBrains Mono** — the only font that matters.

### The Content

Blog posts are Markdown files in `src/content/blog/`. Each one has frontmatter with a title, date, description, and tags. No CMS, no database. Just files in a git repo like nature intended.

### The Deploy

My **Unraid server** runs a cron job every 5 minutes that pulls from GitHub, builds with Astro, and rsyncs to my **SWAG** reverse proxy. My entire deploy process is `git push`. Five minutes later, it's live on [aayush.dev](https://aayush.dev). Just a shell script and a cron job on a server in my closet.

### Where Claude Fits In

Claude runs with full context of the repo — project structure, frontmatter format, tone, design system. So when I say "write a post about X," it writes something that actually fits the site. Not generic filler.

Think of it like a coworker who's read every file in your repo, never needs a standup, works at 3am without complaining, and fits in your pocket.

## The Point

The future didn't show up with flying cars. It showed up as a CLI tool and a phone app that turn my ramblings into published blog posts before my coffee gets cold.

I'll take it.
