// swift-tools-version: 6.0
// Package.swift for sourcekit-lsp support
// This file is only used by the LSP and doesn't interfere with Xcode builds

import PackageDescription

let package = Package(
    name: "Swell",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Swell",
            targets: ["Swell"]
        )
    ],
    targets: [
        .target(
            name: "Swell",
            path: "Swell",
            sources: [
                "SwellApp.swift",
                "Models/Wave.swift",
                "Theme/Theme.swift",
                "Views/WaveComposeView.swift",
                "Views/WaveListView.swift"
            ]
        )
    ]
)
