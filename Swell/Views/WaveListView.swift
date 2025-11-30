//
//  WaveListView.swift
//  Swell
//
//  Created by Dhison Padma on 11/30/25.
//

import SwiftUI
import SwiftData

struct WaveListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Wave.createdAt, order: .reverse) private var waves: [Wave]
    @State private var showingComposeView = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                if waves.isEmpty {
                    emptyStateView
                } else {
                    waveListContent
                }

                // Floating Action Button
                Button {
                    showingComposeView = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Waves")
            .sheet(isPresented: $showingComposeView) {
                ComposeView()
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "water.waves")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("No waves yet")
                .font(.title2)
                .fontWeight(.medium)

            Text("Tap the + button to capture your first wave")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var waveListContent: some View {
        List {
            ForEach(waves) { wave in
                WaveRow(wave: wave)
            }
            .onDelete(perform: deleteWaves)
        }
    }

    private func deleteWaves(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(waves[index])
        }
    }
}

struct WaveRow: View {
    let wave: Wave

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(wave.content)
                .lineLimit(3)
                .font(.body)

            Text(relativeTimestamp(from: wave.createdAt))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func relativeTimestamp(from date: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(date)

        if interval < 60 {
            return "just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes) \(minutes == 1 ? "minute" : "minutes") ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours) \(hours == 1 ? "hour" : "hours") ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days) \(days == 1 ? "day" : "days") ago"
        }
    }
}

#Preview("With Waves") {
    let container = try! ModelContainer(
        for: Wave.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let sampleWaves = [
        Wave(content: "Just had the most amazing idea for a new feature", createdAt: Date().addingTimeInterval(-300)),
        Wave(content: "Reminder to call mom later", createdAt: Date().addingTimeInterval(-3600)),
        Wave(content: "Why do we always overthink the simplest problems? Sometimes the obvious solution is the right one.", createdAt: Date().addingTimeInterval(-7200))
    ]

    for wave in sampleWaves {
        container.mainContext.insert(wave)
    }

    return WaveListView()
        .modelContainer(container)
}

#Preview("Empty State") {
    WaveListView()
        .modelContainer(for: Wave.self, inMemory: true)
}
