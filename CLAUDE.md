# /home/ash — Personal Website & Blog

## Quick Reference

- **Stack:** Astro static site, pure CSS, JetBrains Mono font
- **Deploy:** Push to GitHub → Unraid cron runs `build-and-deploy.sh` every 5 min
- **Site URL:** https://aayush.dev

## Project Structure

```
src/
├── content/blog/          # Blog posts (Markdown with frontmatter)
├── data/games.yaml        # Game tracker (year + title + completed bool)
├── data/projects.yaml     # Projects list (title, description, url, tags)
├── data/server-status.json # Written by deploy script (uptime, build time)
├── components/            # Astro components (Nav, Footer, GameLog, etc.)
├── layouts/Base.astro     # Shared HTML shell
├── pages/                 # Routes (index, projects, blog/, 404)
└── styles/global.css      # All styles, CSS custom properties
```

## Common Tasks

### Add a blog post
Create `src/content/blog/<slug>.md`:
```yaml
---
title: "Post Title"
date: YYYY-MM-DD
description: "Short summary for listing"
tags: ["tag1", "tag2"]
---
Content here...
```
Commit and push. The blog listing has tag filters and sorts newest first.

### Add/update games
Edit `src/data/games.yaml`. Set `completed: true` for finished games. Include platform in title e.g. `"Game Name (Xbox)"`. Grouped by year, newest year first.

### Add a project
Add entry to `src/data/projects.yaml`:
```yaml
- title: "Project Name"
  description: "One-line summary"
  url: "https://github.com/..."
  tags: ["tech1", "tech2"]
```

### Update bio
Edit `src/pages/index.astro` — the `<p class="bio">` section.

### Update social links
Edit `src/components/SocialLinks.astro`.

## Design

- **Theme:** Dark (#111 bg, #fff headings, #888 body, #ff6b6b accent)
- **Font:** JetBrains Mono everywhere
- **Section labels:** `// comment.style` in accent color
- **Tone:** Funny, aloof, professional underneath. Not corporate.

## Build & Deploy

```bash
npm run build    # Build to dist/
npm run dev      # Local dev server at localhost:4321
```

The deploy script (`build-and-deploy.sh`) runs on Unraid via User Scripts cron. It pulls the repo, writes server uptime to `server-status.json`, builds, and rsyncs to SWAG's www directory.

## Rules

- Don't change the design system (colors, font, layout) without asking
- Keep the aloof/funny tone in blog posts and bio
- Always `npm run build` to verify before pushing
- Commit messages: `feat:`, `fix:`, or `chore:` prefix
