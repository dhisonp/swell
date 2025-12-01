import SwiftUI

struct AppColors {
  static let oceanBlue = Color(hex: "0077B6")
  static let sunsetOrange = Color(hex: "FF6B35")
  static let peach = Color(hex: "FFE5D9")
  static let lightBlue = Color(hex: "CAF0F8")
}

struct AppGradients {
  static let sunsetBackground = LinearGradient(
    colors: [AppColors.peach, AppColors.lightBlue],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}

struct FrostedCardStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(.ultraThinMaterial)
      .cornerRadius(16)
      .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
  }
}

struct AccentButtonStyle: ViewModifier {
  let isDisabled: Bool

  func body(content: Content) -> some View {
    content
      .font(.headline)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(isDisabled ? AppColors.sunsetOrange.opacity(0.5) : AppColors.sunsetOrange)
      .cornerRadius(12)
  }
}

extension View {
  func frostedCard() -> some View {
    modifier(FrostedCardStyle())
  }

  func accentButton(disabled: Bool = false) -> some View {
    modifier(AccentButtonStyle(isDisabled: disabled))
  }
}

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 3:  // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6:  // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:  // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }

    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}
