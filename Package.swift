// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "FretCalculator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "FretCalculator", targets: ["FretCalculator"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "FretCalculator",
            dependencies: [],
            swiftSettings: [
                .unsafeFlags(["-suppress-warnings"], .when(configuration: .release))
            ]
        ),
        .testTarget(
            name: "FretCalculatorTests",
            dependencies: ["FretCalculator"]
        )
    ]
)
