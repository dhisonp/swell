# Swell – Claude Code Context

## Project Overview

Swell is a low-friction iOS journaling app. Users capture thoughts quickly; the
app resurfaces them via AI-generated summaries and reflections. "Write it and
forget it" – except you don't forget.

## Tech Stack

- **Language:** Swift 6
- **UI:** SwiftUI (no UIKit unless absolutely necessary)
- **Persistence:** SwiftData (local-first, CloudKit sync later)
- **Concurrency:** Swift async/await (no Combine unless needed)
- **AI Backend:** Cloudflare Worker → Gemini API (Flash for summaries, Pro for
  future features)
- **Notifications:** Local notifications for MVP, APNs later
- **Min iOS:** 17.0 (SwiftData requirement)

## Project Structure

```
/Swell
├── CLAUDE.md
├── SPEC.md
├── Swell.xcodeproj
├── Swell/
│   ├── SwellApp.swift           # App entry, ModelContainer setup
│   ├── Models/
│   │   └── Thought.swift        # SwiftData model
│   ├── Views/
│   │   ├── ContentView.swift    # Main shell / navigation
│   │   ├── ComposeView.swift    # Thought input
│   │   └── EchoView.swift       # Display AI summary
│   ├── Services/
│   │   ├── SwellService.swift   # API calls to edge function
│   │   └── NotificationManager.swift
│   └── Assets.xcassets
└── worker/                      # Cloudflare Worker (later)
    ├── src/index.ts
    └── wrangler.toml
```

## Conventions

### Swift Style

- Use Swift 6 strict concurrency
- Prefer `@Observable` over `@ObservableObject` (iOS 17+)
- Use `@Model` for SwiftData entities
- Keep views small; extract subviews early
- No force unwrapping (`!`) – use guard/if-let
- Use `async let` for parallel fetches

### Naming

- Views: `*View.swift`
- Models: singular noun (`Thought.swift`)
- Services: `*Service.swift` or `*Manager.swift`
- Use descriptive variable names, no abbreviations

### File Organization

- One type per file
- Group by feature, not by type, as app grows
- Keep `Models/`, `Views/`, `Services/` flat until >10 files each

### SwiftData

- Define models with `@Model` macro
- Use `@Attribute(.unique)` for IDs
- ModelContainer configured once in `SwellApp.swift`
- Pass `modelContext` via environment

### Error Handling

- Use `Result` or `throws` – no silent failures
- User-facing errors → show alert
- Log errors with `os.Logger`

## Current Sprint: MVP

**Goal:** User can write a thought → receive daily AI summary notification

### MVP Scope

- [x] Project setup
- [ ] Thought model (id, content, timestamp)
- [ ] ComposeView – single text field, save button
- [ ] Schedule daily local notification (user picks time)
- [ ] SwellService – fetch summary from edge function
- [ ] EchoView – display today's summary
- [ ] Cloudflare Worker – Gemini integration

### Out of Scope (v1.1+)

- Mood/tags
- Weekly summaries
- History browsing
- Cloud sync
- Onboarding
- Widget

## AI Integration Notes

- Keep Gemini API key server-side only (in Cloudflare Worker)
- Use Gemini Flash 2.5 for daily summaries (fast, cheap)
- Prompt strategy: summarize + one reflective question
- Batch recent thoughts (last 24h) in single API call

## Commands

```bash
# Run Claude Code from project root
cd /path/to/Swell && claude

# Build from terminal (optional)
xcodebuild -scheme Swell -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Notes for Claude Code

- Xcode project already exists – only create/modify .swift files
- Do not touch .xcodeproj or .pbxproj files
- When adding new files, tell user to add to Xcode target manually
- Prefer small, focused changes over large rewrites
- Always consider iOS 17+ APIs first
