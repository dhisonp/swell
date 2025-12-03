//
//  SwellView.swift
//  Swell
//
//  Created by dhison on 12/3/25.
//

import SwiftData
import SwiftUI

struct SwellView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss
  @Query(sort: \Wave.createdAt, order: .reverse) private var allWaves: [Wave]

  @State private var summary: String?
  @State private var reflection: String?
  @State private var isLoading: Bool = true
  @State private var errorMessage: String?

  private let service = SwellService()

  var body: some View {
    ZStack {
      AppGradients.sunsetBackground
        .ignoresSafeArea()

      VStack(spacing: 24) {
        Spacer()

        if !isLoading {
          Text("Swell for the day:")
            .font(AppFonts.largeTitle)
            .foregroundStyle(AppColors.oceanBlue)
        }

        if isLoading {
          SwellLoadingView()
        } else if let error = errorMessage {
          errorView(message: error)
        } else {
          contentView
        }

        Button(action: {
          dismiss()
        }) {
          Text("Make more Waves...")
            .font(AppFonts.callout)
            .foregroundStyle(.secondary)
            .underline()
            .padding(.vertical, 10)
        }

        Spacer()
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 20)
    }
    .task {
      await loadSwell()
    }
  }

  private func errorView(message: String) -> some View {
    VStack(spacing: 16) {
      Image(systemName: "exclamationmark.triangle")
        .font(.largeTitle)
        .foregroundStyle(AppColors.sunsetOrange)
      Text("Rough winds today...")
        .font(AppFonts.title)
        .foregroundStyle(AppColors.sunsetOrange)
      Text(message)
        .font(AppFonts.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)

      Button(action: {
        Task { await loadSwell() }
      }) {
        Text("Try Again")
          .accentButton()
      }
      .padding(.top, 10)
    }
    .padding(30)
    .background(.ultraThinMaterial)
    .cornerRadius(20)
    .shadow(color: AppColors.sunsetOrange.opacity(0.2), radius: 15)
  }

  private var contentView: some View {
    SwellContentView(summary: summary, reflection: reflection)
  }

  private func loadSwell() async {
    isLoading = true
    errorMessage = nil

    let yesterday = Date().addingTimeInterval(-24 * 3600)
    let recentWaves = allWaves.filter { $0.createdAt >= yesterday }

    guard !recentWaves.isEmpty else {
      withAnimation {
        isLoading = false
      }
      return
    }

    do {
      let response = try await service.fetchSwell(waves: recentWaves)
      withAnimation {
        summary = response.summary
        reflection = response.reflection
        isLoading = false
      }
    } catch {
      print("Error loading swell: \(error)")
      withAnimation {
        isLoading = false
        errorMessage = error.localizedDescription
      }
    }
  }
}

#Preview {
  SwellView()
    .modelContainer(for: Wave.self, inMemory: true)
}
