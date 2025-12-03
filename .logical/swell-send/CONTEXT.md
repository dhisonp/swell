# Context for Swell Worker Integration

## Project Overview
Swell is an iOS journaling app that uses AI to summarize user thoughts ("Waves") and provide reflections.

## Current State

*   **Wave Model:** SwiftData is used for local persistence of `Wave` objects (id, content, createdAt).
*   **Worker (`worker/src/index.ts`):**
    *   A Cloudflare Worker is set up to receive POST requests containing an array of `Wave` objects.
    *   It uses the Gemini 2.5 Flash API to generate a 2-3 sentence summary and one reflective question from these waves.
    *   The worker responds with a JSON object containing `summary` and `reflection`.
    *   API key (`GEMINI_API_KEY`) is securely handled by the worker.
*   **Client-side (`Swell/`):**
    *   `WaveComposeView`: For capturing new waves.
    *   `WaveListView`: For viewing existing waves.
    *   `SwellService.swift`: Client-side service, likely where the network logic for fetching summaries will reside.
    *   `SwellView.swift`: Designed to display AI summaries and reflections.

## Task Focus
The primary focus is to establish the communication between the iOS app (specifically `SwellService` and `SwellView`) and the Cloudflare Worker to enable the AI summary feature. This involves gathering waves, making the network call, and displaying the results.