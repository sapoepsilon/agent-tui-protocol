// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "agent-tui-protocol",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "WhisperaAgents", targets: ["WhisperaAgents"]),
        .library(name: "WhisperaHerdr", targets: ["WhisperaHerdr"])
    ],
    targets: [
        .target(name: "WhisperaAgents"),
        .target(name: "WhisperaHerdr", dependencies: ["WhisperaAgents"]),
        .testTarget(name: "WhisperaAgentsTests", dependencies: ["WhisperaAgents", "WhisperaHerdr"])
    ]
)
