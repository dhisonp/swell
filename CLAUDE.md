# Swell – Claude Code Context

## Overview

Low-friction iOS journaling app. Capture thoughts quickly → AI resurfaces them
via summaries/reflections.

## Tech Stack

- Swift 6, SwiftUI, SwiftData (local-first)
- Swift async/await (no Combine)
- Cloudflare Worker → Gemini API (Flash for summaries)
- Min iOS: 17.0

## Project Structure

```
/Swell
├── Swell/
│   ├── SwellApp.swift
│   ├── WaveComposeView.swift    # Primary compose screen
│   ├── WaveListView.swift       # Secondary screen (push nav)
│   ├── Wave.swift               # @Model (id, content, createdAt)
│   ├── Theme.swift              # Design system (colors, gradients, modifiers)
│   └── Services/                # (future: SwellService, NotificationManager)
└── worker/                      # (future: Cloudflare Worker)
```

## Design System

- **Theme:** "Sunset surfing" – calm, warm, inviting
- **Colors:** Ocean Blue (#0077B6), Sunset Orange (#FF6B35)
- **Background:** Gradient (pale peach → light blue)
- **Style:** Frosted cards, rounded buttons, smooth gradients

## Conventions

- Swift 6 strict concurrency, `@Observable` over `@ObservableObject`
- No force unwrapping, use guard/if-let
- Views: `*View.swift`, Models: singular noun
- One type per file, flat structure until >10 files per folder
- User-facing errors → show alert, log with `os.Logger`
- Never comment a code block on 'what' it does, only 'why' it does what it does
  if it looks like it may raise suspicion or questions

## Current State

### Implemented ✅

- **Wave Model:** SwiftData with UUID id
- **WaveComposeView:** Primary compose screen (gradient bg, frosted TextEditor,
  auto-focus)
- **WaveListView:** Secondary screen (push nav, frosted wave cards,
  swipe-to-delete)
- **Theme System:** Centralized colors/gradients in `Theme.swift`
- **Navigation:** Push nav from compose → wave list
- **Data Persistence:** Local SwiftData storage

### MVP Remaining

- [ ] Daily local notification (user picks time)
- [ ] SwellService – fetch summary from edge function
- [ ] SwellView – display AI summary
- [ ] Cloudflare Worker – Gemini integration

### Out of Scope (v1.1+)

- Mood/tags, weekly summaries, history browsing, cloud sync, onboarding, widget

## AI Integration (Future)

- Gemini API key server-side only (Cloudflare Worker)
- Gemini Flash 2.5 for summaries (batch last 24h waves)
- Prompt: summarize + one reflective question

## Notes

- Only modify .swift files (Xcode project exists)
- Prefer small, focused changes
