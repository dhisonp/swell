//
//  SwellApp.swift
//  Swell
//
//  Created by Dhison Padma on 11/30/25.
//

import SwiftData
import SwiftUI

@main
struct SwellApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Wave.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  var body: some Scene {
    WindowGroup {
      WaveComposeView()
    }
    .modelContainer(sharedModelContainer)
  }
}
