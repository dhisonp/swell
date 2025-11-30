# Swell

A minimalist iOS journaling app that captures your thoughts effortlessly and
resurfaces them through AI-powered summaries and reflections.

## Features

- **Quick Capture** – Frictionless journaling with auto-focus compose screen
- **Local-First** – All data stored locally using SwiftData
- **AI Summaries** – Daily reflections powered by Gemini Flash (coming soon)
- **Beautiful Design** – Sunset-inspired gradient UI with frosted glass elements

## Tech Stack

- **iOS:** Swift 6, SwiftUI, SwiftData
- **AI:** Gemini Flash 2.5 via Cloudflare Workers
- **Minimum iOS:** 17.0

## Project Structure

```
/Swell
├── Swell/
│   ├── SwellApp.swift
│   ├── ContentView.swift        # Primary compose screen
│   ├── Models/Wave.swift        # SwiftData model
│   ├── Views/WaveListView.swift # Wave history
│   ├── Theme/Theme.swift        # Design system
│   └── Services/                # (future)
└── worker/                      # Cloudflare Worker (future)
```

## Design System

- **Theme:** Sunset surfing – calm, warm, inviting
- **Colors:** Ocean Blue (#0077B6), Sunset Orange (#FF6B35)
- **Style:** Frosted cards, smooth gradients, rounded buttons

## Development

Built with Swift 6 strict concurrency and SwiftUI best practices. Uses
`@Observable` for state management and SwiftData for persistence.

## Roadmap

### Current (MVP)

- [x] Quick-capture compose screen
- [x] Wave list with swipe-to-delete
- [x] Local data persistence
- [ ] Daily notifications
- [ ] AI-powered summaries
- [ ] Cloudflare Worker integration

### Future (v1.1+)

- Mood tracking and tags
- Weekly summaries
- History browsing
- Cloud sync
- Widget support

## License

MIT
