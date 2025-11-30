//
//  WaveListView.swift
//  Swell
//
//  Secondary screen showing all waves with sunset surfing theme
//

import SwiftUI
import SwiftData

struct WaveListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Wave.createdAt, order: .reverse) private var waves: [Wave]

    var body: some View {
        ZStack {
            // Sunset gradient background
            AppGradients.sunsetBackground
                .ignoresSafeArea()

            if waves.isEmpty {
                emptyStateView
            } else {
                waveListContent
            }
        }
        .navigationTitle("Waves")
        .navigationBarTitleDisplayMode(.large)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "water.waves")
                .font(.system(size: 64))
                .foregroundStyle(AppColors.oceanBlue.opacity(0.6))

            Text("No waves yet")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.oceanBlue)

            Text("Capture your first wave from the main screen")
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
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteWaves)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
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
                .foregroundStyle(.primary)

            Text(relativeTimestamp(from: wave.createdAt))
                .font(.caption)
                .foregroundStyle(AppColors.oceanBlue)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frostedCard()
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

    return NavigationStack {
        WaveListView()
            .modelContainer(container)
    }
}

#Preview("Empty State") {
    NavigationStack {
        WaveListView()
            .modelContainer(for: Wave.self, inMemory: true)
    }
}
