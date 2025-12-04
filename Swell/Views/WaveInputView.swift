import SwiftUI

struct WaveInputView: View {
  @Binding var text: String
  var isFocused: FocusState<Bool>.Binding

  var body: some View {
    TextEditor(text: $text)
      .focused(isFocused)
      .font(AppFonts.body)
      .frame(height: 200)
      .padding()
      .scrollContentBackground(.hidden)
      .frostedCard()
      .padding(.horizontal, 32)
  }
}

#Preview {
  @Previewable @State var text = "Preview wave content"
  @Previewable @FocusState var isFocused: Bool

  ZStack {
    AppGradients.sunsetBackground
    WaveInputView(text: $text, isFocused: $isFocused)
  }
}
