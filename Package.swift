// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "markpages-website",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "app",
            targets: ["App"]
        ),
        .library(
            name: "Markpages",
            type: .dynamic,
            targets: ["Markpages"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.8.0"),
        .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: ["Markpages"]
        ),
        .target(
            name: "Markpages",
            dependencies: ["Publish", "SplashPublishPlugin"]
        ),
        .testTarget(name: "MarkpagesTests", dependencies: ["Markpages"])
    ]
)
