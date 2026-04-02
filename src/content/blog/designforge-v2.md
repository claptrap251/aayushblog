---
title: "DesignForge v2: From Design Review Tool to AI-Powered Knowledge Base"
date: 2026-03-30
description: "DesignForge v2 adds GitHub markdown scraping, a CLI tool for AI agents, and a Claude Code skill. It's like Context7, but for your own data."
tags: ["designforge", "ai", "claude", "cli", "open-source", "ai-assisted"]
revisions: 1
---

> **Revision counter:** I asked Claude to fix this post **1 time** before it got the details right. Peak AI experience.

DesignForge started as a self-hosted design review platform — upload designs, pin comments on them, collaborate asynchronously. v1 was about getting the core right. v2 turns it into something bigger: a knowledge base that AI agents can tap into while they work.

## What v1 Shipped

For anyone catching up, DesignForge v1 was a complete design review platform built with Next.js, TypeScript, Prisma, and SQLite. Fully self-hosted, zero external dependencies. Here's what it included:

- **Image and Markdown design uploads** with version history
- **Pin comments directly on designs** — text-anchored for markdown, coordinate-based for images
- **Threaded replies** on comments with resolve/discard states
- **Shared workspaces** with per-user namespaces and folder organization
- **Design status workflow** — Draft, In Review, Approved
- **Export to multiple formats** — Markdown, HTML, Word, Confluence
- **GitHub backup and restore** with human-readable file structure
- **Dark mode** because obviously
- **CLI-ready API** with HTTP Basic Auth for programmatic access
- **Docker support** for easy deployment
- **Document similarity engine** — automatically finds related designs within a project

### Document Relations

When you open a markdown design, a "Related" panel shows other documents in the project ranked by relevance score. This isn't a keyword search — it's a hybrid similarity engine that runs entirely locally.

The engine computes three signals and blends them:

1. **Document-level TF-IDF** — broad topical overlap across the full document
2. **Chunk-level TF-IDF** — splits each markdown file by headings and finds the best-matching section pair between two documents, so a one-paragraph section overlap doesn't get buried by unrelated content
3. **Embedding similarity** (optional) — local `all-MiniLM-L6-v2` model via `@xenova/transformers`, enabled with `SIMILARITY_USE_EMBEDDINGS=true`. No external API calls, runs on your machine.

Each result shows the relevance percentage, which sections matched, and the shared terms as pill tags. No configuration required — it runs on every project automatically.

This is the engine that powers `dfcli related` in v2. When you hand the CLI a local file, it scores that file against your entire DesignForge project using the same pipeline.

The whole thing runs from a single `npm start` or `docker compose up`. No cloud services, no subscriptions, no data leaving your machine.

## What Changed in v2

v2 is about one idea: **make your team's knowledge accessible to AI agents**.

### GitHub Markdown Scraper

The headline feature. DesignForge can now scrape all markdown files from any GitHub organization or user account and import them into your project.

**How it works:**
- Admin configures a scrape target (org/user, API token, target project)
- Select which repos and branches to include via a checklist UI
- Scheduler runs every 12 hours (configurable) or trigger manually
- Scraped files organized by repo: `scrapedata/repo-name/path/to/file`
- An auto-generated **Index** provides a compact lookup: `repo: file1.md, file2.md, ...`
- Supports GitHub Enterprise via configurable API URL

**Why this matters:** Your org's documentation, READMEs, design docs, ADRs — they're all scattered across GitHub repos. The scraper pulls them into one place where they can be searched, compared, and served to AI agents.

The admin UI got a full rewrite with a tabbed layout. The backup configuration also moved from environment variables to the database, with encrypted tokens (AES-256-GCM).

### dfcli — CLI for AI Agents

A standalone CLI tool that AI coding agents call to interact with DesignForge. Three commands:

```bash
# Find related docs (the primary workflow command)
dfcli related ./my-design.md --project "Mobile App" --include-content

# Pull a file and its linked docs
dfcli pull "scrapedata/repo/README" --project "Mobile App" --depth 1

# Upload files to a project
dfcli upload ./specs/*.md --project "Mobile App" --dest specs
```

The `related` command is the star. Give it a local file, and it finds semantically related documents across your entire project — including scraped GitHub docs. The similarity engine uses TF-IDF scoring to rank results.

**Progressive auth:** Read-only queries work without credentials. If you set a token, `related` automatically uploads your file to DesignForge before searching — so your work feeds back into the knowledge base.

### API Tokens

New authentication method for machine access. Generate tokens at `/settings/tokens`, set `DFCLI_TOKEN` in your environment, done. Multiple tokens per user, SHA-256 hashed at rest, Bearer header auth. Cleaner than storing passwords in env vars.

### Claude Code Skill

The final piece. A Claude Code skill (`.claude/skills/designforge.md`) that agents invoke to automatically fetch related context from DesignForge. When an agent starts working on a feature, the skill:

1. Queries DesignForge with the current file/context
2. Finds related design docs, specs, and scraped GitHub documentation
3. Loads them into the context window

It's like having an agent that reads all the relevant docs before writing code. And because the scraper keeps the knowledge base fresh, the agent always has up-to-date context.

### Folder Breadcrumbs

Small but useful — the design viewer now shows the full folder path (clickable) above the design name. Related designs also show their folder paths. So when you see a related doc from `scrapedata/claude-code/docs/getting-started`, you know exactly where it came from.

## The Context7 Comparison

If you've used [Context7](https://context7.com), you know the idea: index library docs so AI agents can pull current documentation instead of relying on training data. DesignForge v2 is the same concept, but for **your private data**.

- Context7 indexes public library docs → DesignForge scrapes your org's GitHub repos
- Context7 serves docs to agents via MCP → DesignForge serves docs via CLI + skill
- Context7 is a hosted service → DesignForge is fully self-hosted

Your internal design decisions, API specs, architecture docs, meeting notes — things that would never be in a public index — are now searchable and servable to AI agents working on your codebase.

## What's Next

- **MCP server** to replace the CLI with a proper Model Context Protocol integration
- **Webhook sync** for real-time updates instead of cron
- **Smart caching** in the CLI to avoid re-fetching unchanged docs
- **Multi-project related search** across the entire DesignForge instance

## Try It

DesignForge is MIT licensed and fully self-hosted. Clone it, `npm install`, `npm run dev`, and you're running. The scraper, CLI, and Claude skill are all included.

[GitHub: claptrap251/DesignForge](https://github.com/claptrap251/DesignForge)

```bash
git clone https://github.com/claptrap251/DesignForge.git
cd DesignForge
cp .env.example .env
npx prisma db push
npm run dev
```

