//
//  ContentView.swift
//  Swell
//
//  Created by Dhison Padma on 11/30/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        WaveListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Wave.self, inMemory: true)
}
