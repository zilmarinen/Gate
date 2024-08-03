// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gate",
    platforms: [.macOS(.v14),
                .iOS(.v17)],
    products: [
        .library(name: "Gate",
                 targets: ["Gate"]),
    ],
    dependencies: [
        .package(path: "../Bivouac"),
        .package(url: "git@github.com:nicklockwood/Euclid.git",
                 branch: "develop"),
        .package(url: "git@github.com:3Squared/PeakOperation.git",
                         branch: "master"),
    ],
    targets: [
        .target(name: "Gate",
                dependencies: ["Bivouac",
                               "Euclid",
                               "PeakOperation"]),
    ]
)
