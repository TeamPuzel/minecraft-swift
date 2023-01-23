// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "minecraft-swift",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "Minecraft", targets: ["Minecraft"])],
    targets: [
        // MARK: - Game
        .executableTarget(name: "Minecraft", dependencies: ["GLAD", "SDL2"]),
        // MARK: - Libraries
        .target(name: "GLAD"),
        .systemLibrary(
            name: "SDL2",
            pkgConfig: "sdl2",
            providers: [
                .brewItem(["sdl2"]),
                .aptItem(["libsdl2-dev"])
            ]
        ),
        // MARK: - Tests
        .testTarget(name: "MinecraftTests", dependencies: ["Minecraft"])
    ]
)
