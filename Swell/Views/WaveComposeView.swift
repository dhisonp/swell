import SwiftData
import SwiftUI

struct WaveComposeView: View {
  @Environment(\.modelContext) private var modelContext
  @FocusState private var isTextFieldFocused: Bool
  @State private var content: String = ""

  var body: some View {
    NavigationStack {
      ZStack {
        AppGradients.sunsetBackground
          .ignoresSafeArea()

        VStack(spacing: 24) {
          Spacer()

          Text("Capture a Wave")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(AppColors.oceanBlue)

          TextEditor(text: $content)
            .focused($isTextFieldFocused)
            .frame(height: 200)
            .padding()
            .scrollContentBackground(.hidden)
            .frostedCard()
            .padding(.horizontal, 32)

          Button {
            saveWave()
          } label: {
            Text("Save")
          }
          .accentButton(disabled: isSaveDisabled)
          .disabled(isSaveDisabled)
          .padding(.horizontal, 32)

          Spacer()

          NavigationLink {
            WaveListView()
          } label: {
            Text("View Waves")
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
          .padding(.bottom, 32)
        }
      }
      .onAppear {
        isTextFieldFocused = true
      }
    }
  }

  private var isSaveDisabled: Bool {
    content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  private func saveWave() {
    let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedContent.isEmpty else { return }

    let wave = Wave(content: trimmedContent)
    modelContext.insert(wave)

    do {
      try modelContext.save()
      content = ""
      isTextFieldFocused = true
    } catch {
      print("Error saving wave: \(error)")
    }
  }
}

#Preview {
  WaveComposeView()
    .modelContainer(for: Wave.self, inMemory: true)
}
