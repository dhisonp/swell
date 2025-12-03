# Plan for Swell Worker Integration

## Objective
Implement the business logic in the Swell iOS application to send user "Waves" to the Cloudflare Worker, process the AI-generated summary and reflection, and display them in the `SwellView`.

## Subtasks

1.  **Identify data source:** Determine how to gather the `Wave` objects from SwiftData that need to be sent to the worker. This will likely involve `SwellService.swift`.
2.  **Network request implementation:** Write the Swift code to construct and send an HTTP POST request to the Cloudflare Worker endpoint, including the `Wave` data.
3.  **Response handling:** Parse the JSON response from the worker to extract the `summary` and `reflection` into appropriate Swift data structures.
4.  **Integration with SwellView:** Connect the fetched summary and reflection data with the `SwellView` to ensure it displays correctly.