//
//  SwellLoadingView.swift
//  Swell
//
//  Created by dhison on 12/3/25.
//

import SwiftUI

struct SwellLoadingView: View {
  var body: some View {
    VStack(spacing: 20) {
      ProgressView()
        .scaleEffect(1.5)
        .tint(AppColors.oceanBlue)
      Text("Eyes on the horizon...")
        .font(AppFonts.title)
        .foregroundStyle(AppColors.oceanBlue)
    }
    .frame(maxWidth: .infinity)
    .padding(40)
    .background(.ultraThinMaterial)
    .cornerRadius(20)
  }
}

#Preview {
  SwellLoadingView()
}
