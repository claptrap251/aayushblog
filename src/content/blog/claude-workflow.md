---
title: "I'm Using AI to Write This Post About Using AI"
date: 2026-03-29
description: "How I use Claude to go from idea to published blog post in minutes. The future is already here and it's weirdly casual."
tags: ["meta", "ai", "astro", "workflow", "ai-assisted"]
---

Yes, this post was made with the help of Claude. Yes, I see the irony. Let's move on.

![The future is now](https://media4.giphy.com/media/v1.Y2lkPTZjMDliOTUyemIzem83enk5b2pvYTg2eW93eGQ5eHMxNjhhNTh5eXU1djFjbzlzdCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/KpACNEh8jXK2Q/giphy.gif)

## The Old Way

Think of a post idea. Open the editor. Write some frontmatter from memory. Get the date format wrong. Fix the date format. Write an intro. Go make coffee. Come back. Write the rest. Realize you forgot a tag. Rebuild. Push. Wait.

It worked. It was fine. But "fine" is not exactly the pitch for a tech blog in 2026.

## The New Way

I open my terminal, tell Claude what I want to write about, and it creates the Markdown file with the right frontmatter, the right tone, and drops it into the right directory. I read it, tweak it, push it. Done.

The part that used to take the longest — going from "I have a thought" to "there's a file with words in it" — now takes seconds. That feels like the future, except the future is just a guy in his office talking to a CLI tool. Underwhelming aesthetics, incredible results.

## How the Blog Actually Works

Since we're already being meta, here's how the whole thing is wired up:

### The Stack

- **Astro** — static site generator. Fast, simple, Markdown-native.
- **Pure CSS** with custom properties — no Tailwind, no component library. Just `var(--accent)` and good decisions.
- **JetBrains Mono** — the only font that matters.

### The Content

Blog posts are Markdown files in `src/content/blog/`. Each one has frontmatter with a title, date, description, and tags. No CMS, no database, no admin panel with a forgot-password flow. Just files in a git repo like nature intended.

```yaml
---
title: "Post Title"
date: 2026-03-29
description: "A short summary"
tags: ["tag1", "tag2"]
---
Your post goes here.
```

### The Deploy

This is my favorite part. My **Unraid server** runs a cron job every 5 minutes that:

1. Pulls the latest from GitHub
2. Builds the site with Astro
3. Rsyncs the output to my **SWAG** reverse proxy's web directory

My entire deploy process is `git push`. Five minutes later, it's live on [aayush.dev](https://aayush.dev). No Vercel, no Netlify, no CI/CD pipeline with 47 steps and a Slack notification. Just a shell script and a cron job running on a server in my closet. Beautiful.

### Where Claude Fits In

Claude Code runs in my terminal with full context of the repo. It knows the project structure, the frontmatter format, the tone, the design system — everything. So when I say "write a post about X," it doesn't spit out generic filler. It writes something that actually fits the site.

Think of it like having a coworker who's read every file in your repo, never needs a standup, and works at 3am without complaining. I handle the ideas and direction. Claude handles the scaffolding and first drafts. We're a good team.

## The Actual Workflow

Here's what a blog post looks like from thought to published:

1. **I have an idea** — the hard part that no AI can do for me (yet)
2. **I describe it to Claude** — tone, topic, any links or media I want included
3. **Claude creates the file** — correct format, right directory, solid first draft
4. **I review and edit** — add my takes, cut what doesn't land, make it mine
5. **`git push`** — the Unraid cron handles the rest
6. **It's live** — five minutes, no drama

The whole thing from "hmm I should write about this" to "it's on the internet" can happen in one sitting. That used to take me days, mostly because I'd procrastinate between steps. Hard to procrastinate when step 2 through 5 happen in the same terminal session.

## The Point

The future didn't show up with flying cars. It showed up as a CLI tool that turns my stream-of-consciousness ramblings into published blog posts before my coffee gets cold.

I'll take it.
