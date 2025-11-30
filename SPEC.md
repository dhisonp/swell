# Swell – Product Spec

## Vision

A thought capture app that requires nothing from you after writing. No
organizing, no tagging, no revisiting. Swell holds your thoughts and returns
them to you – distilled, reflected, at the right moment.

## Problem

- You have thoughts throughout the day
- You write them somewhere (notes, docs, messages to self)
- They pile up, become chaotic, never get revisited
- The value decays; you forget what you were thinking

## Solution

Swell is "write it and forget it" – except you don't forget. The app captures
thoughts with zero friction and uses AI to:

1. Summarize what's on your mind
2. Surface patterns you might miss
3. Prompt gentle reflection

You connect with your thoughts through Swell's output, not by re-reading
entries.

---

## MVP User Flow

### Capture

1. Open app
2. See single text field (keyboard auto-focused)
3. Write thought
4. Tap "Done" or swipe down
5. Thought saved, app closes or resets

### Receive

1. Daily notification at user-chosen time (default: 9am)
2. Notification preview shows first line of summary
3. Tap → opens EchoView with full summary

---

## Data Model

### Thought

| Field     | Type   | Notes                       |
| --------- | ------ | --------------------------- |
| id        | UUID   | Primary key, auto-generated |
| content   | String | The raw thought             |
| createdAt | Date   | Timestamp                   |

### Echo (v1.1 – not MVP)

| Field      | Type   | Notes                          |
| ---------- | ------ | ------------------------------ |
| id         | UUID   | Primary key                    |
| date       | Date   | Which day this covers          |
| summary    | String | AI-generated summary           |
| reflection | String | AI-generated question/prompt   |
| thoughtIDs | [UUID] | Thoughts included in this echo |

For MVP, we don't persist Echos – just fetch and display.

---

## Screens

### ComposeView (MVP)

- Auto-focused multiline text field
- Minimal chrome: just the input
- "Done" button (or keyboard dismiss)
- Optional: character count (subtle)
- No title field, no tags, no mood

### EchoView (MVP)

- Today's AI summary
- One reflective question
- Subtle "View thoughts" link (shows raw entries)
- Pull-to-refresh (re-fetch summary)

### SettingsView (MVP)

- Notification time picker
- That's it for MVP

### HistoryView (v1.1)

- Calendar or list of past days
- Tap day → see that day's Echo + raw thoughts

---

## AI Strategy

### Daily Echo Prompt

```
You are a thoughtful reflection assistant. The user has written these thoughts over the past 24 hours:

<thoughts>
{thoughts_json}
</thoughts>

Generate:
1. A 2-3 sentence summary of what's on their mind
2. One gentle, open-ended reflective question

Keep tone warm but not saccharine. Be specific to their actual thoughts, not generic.
Do not give advice unless explicitly relevant. Focus on reflection.

Respond in JSON:
{
  "summary": "...",
  "reflection": "..."
}
```

### Model Selection

- Daily summary: Gemini 2.5 Flash (speed, cost)
- Weekly digest (v1.1): Gemini 2.5 Pro or 3 Pro (deeper synthesis)

### Edge Cases

- No thoughts in 24h → skip notification or send encouragement
- Single thought → still summarize, acknowledge brevity
- Very long thought → truncate to last 4000 chars per thought

---

## Notification Strategy

### MVP: Local Notifications

- User sets preferred time in Settings
- App schedules repeating daily notification
- On notification tap: app fetches summary, shows EchoView
- If app in foreground at scheduled time: show in-app prompt

### v1.1: Push Notifications

- Server generates summary overnight
- Push sent with summary preview
- Richer notification content

---

## Technical Decisions

| Decision            | Choice            | Rationale                                |
| ------------------- | ----------------- | ---------------------------------------- |
| Persistence         | SwiftData         | Modern, local-first, easy CloudKit later |
| Min iOS             | 17.0              | Required for SwiftData, @Observable      |
| AI hosting          | Cloudflare Worker | Cheap, fast, keeps API key secure        |
| Notifications (MVP) | Local             | No server dependency                     |
| Sync                | None (MVP)        | Add CloudKit in v1.1                     |

---

## Success Metrics (Post-Launch)

- Daily active captures (target: 1+ thought/day)
- Notification open rate (target: >40%)
- Retention D7 (target: >30%)
- User sentiment in reviews

---

## Open Questions

- [ ] Should thoughts have optional titles? (Leaning no)
- [ ] Voice input? (v1.2 maybe)
- [ ] Widget showing latest Echo? (v1.1)
- [ ] Apple Watch quick capture? (v1.2)

---

## Milestones

### MVP (v1.0)

- Capture thought
- Daily local notification
- AI summary via edge function
- Settings: notification time

### v1.1

- CloudKit sync
- History view
- Weekly digest
- Persist Echos locally

### v1.2

- Widget
- Voice input
- Apple Watch app
- Mood/tags (optional)
