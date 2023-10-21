// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gate",
    platforms: [.macOS(.v11),
                .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Gate",
            targets: ["Gate"]),
    ],
    dependencies: [
        .package(url: "git@github.com:nicklockwood/Euclid.git", branch: "main"),
        .package(url: "git@github.com:3Squared/PeakOperation.git", branch: "develop"),
        .package(path: "../Bivouac"),
    ],
    targets: [
        .target(
            name: "Gate",
            dependencies: ["Bivouac",
                           "Euclid",
                           "PeakOperation"]),
    ]
)
