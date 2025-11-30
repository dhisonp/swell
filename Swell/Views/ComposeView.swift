//
//  ComposeView.swift
//  Swell
//
//  Created by Dhison Padma on 11/30/25.
//

import SwiftUI
import SwiftData

struct ComposeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @State private var content: String = ""

    var body: some View {
        NavigationStack {
            TextEditor(text: $content)
                .focused($isTextFieldFocused)
                .padding()
                .navigationTitle("New Wave")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveWave()
                        }
                        .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .onAppear {
                    isTextFieldFocused = true
                }
        }
    }

    private func saveWave() {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }

        let wave = Wave(content: trimmedContent)
        modelContext.insert(wave)

        do {
            try modelContext.save()
        } catch {
            print("Error saving wave: \(error)")
        }

        dismiss()
    }
}

#Preview {
    ComposeView()
        .modelContainer(for: Wave.self, inMemory: true)
}
