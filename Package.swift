// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "moa",
    products: [
        .library(name: "moa", targets: ["moa"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "moa", dependencies: [], path: "moa"),
        .testTarget(
            name: "moaTests",
            dependencies: ["moa"],
            path: "moaTests"
        )
    ]
)
