// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CAREAIDemoCore",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "CAREAIDemoCore", targets: ["CAREAIDemoCore"])
    ],
    targets: [
        .target(name: "CAREAIDemoCore", path: "Sources/CAREAIDemoCore"),
        .testTarget(name: "CAREAIDemoCoreTests", dependencies: ["CAREAIDemoCore"], path: "Tests/CAREAIDemoCoreTests")
    ]
)
