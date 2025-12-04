import SwiftUI

struct SwellContentView: View {
  let summary: String?
  let reflection: String?

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      if let summary = summary {
        Text(summary)
          .font(AppFonts.body)
          .foregroundStyle(.primary)
          .lineSpacing(4)
          .frame(maxWidth: .infinity, alignment: .leading)
      } else {
        Text("Flat waters. Find more Waves to make a Swell!")
          .font(AppFonts.body)
          .foregroundStyle(.primary)
          .frame(maxWidth: .infinity, alignment: .center)
      }

      if let reflection = reflection, !reflection.isEmpty {
        Divider()
          .background(AppColors.oceanBlue.opacity(0.5))
          .padding(.vertical, 8)

        Text("Reflection:")
          .font(AppFonts.title2)
          .foregroundStyle(AppColors.oceanBlue)

        Text(reflection)
          .font(AppFonts.callout)
          .foregroundStyle(.secondary)
          .lineSpacing(3)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding(30)
    .background(.ultraThinMaterial)
    .cornerRadius(24)
    .overlay(
      RoundedRectangle(cornerRadius: 24)
        .stroke(.white.opacity(0.5), lineWidth: 1)
    )
    .shadow(color: AppColors.oceanBlue.opacity(0.4), radius: 30, x: 0, y: 10)
  }
}

#Preview("Normal Content") {
  ZStack {
    AppGradients.sunsetBackground
      .ignoresSafeArea()
    SwellContentView(
      summary:
        "You are a very handsome man. However, you are also a very handsome woman. So what are you? You are a very handsome person. You are a very handsome man. However, you are also a very handsome woman. So what are you? You are a very handsome person.",
      reflection:
        "Can you be more handsome, or is handsome just a concept? What is then, the alternative, other than the deared pretty?"
    )
  }
}

#Preview("Long Content") {
  ZStack {
    AppGradients.sunsetBackground
      .ignoresSafeArea()
    SwellContentView(
      summary: String(
        repeating:
          "This is a long summary of your day. It goes on and on to demonstrate the scrolling capability of the view. ",
        count: 5
      ),
      reflection:
        "This is a reflection on your day. It also might be quite long depending on how much you wrote."
    )
    .padding()
  }
}

#Preview("Empty State") {
  ZStack {
    AppGradients.sunsetBackground
      .ignoresSafeArea()
    SwellContentView(summary: nil, reflection: nil)
      .padding()
  }
}
