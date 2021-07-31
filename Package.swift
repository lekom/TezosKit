// swift-tools-version:5.3

import PackageDescription
 
let package = Package(
    name: "TezosKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "TezosKit",
            targets: ["TezosKit"]),
    ],
    dependencies: [
        .package(name: "BigInt", url: "https://github.com/attaswift/BigInt", from: "5.0.0"),
        .package(name: "PromiseKit", url: "https://github.com/mxcl/PromiseKit", from: "6.13.1"),
        .package(name: "Base58Swift", url: "https://github.com/keefertaylor/Base58Swift", from: "2.1.14"),
        .package(name: "MnemonicKit", url: "https://github.com/lekom/MnemonicKit", .branch("master")),
        .package(name: "Sodium", url: "https://github.com/jedisct1/swift-sodium", from: "0.8.0"),
        .package(name: "CryptoSwift", url: "https://github.com/krzyzanowskim/CryptoSwift", from: "1.3.0"),
        .package(name: "secp256k1", url: "https://github.com/keefertaylor/secp256k1.swift", from: "8.0.6"),
        .package(name: "DTTJailbreakDetection", url: "https://github.com/lekom/DTTJailbreakDetection", .branch("master"))
    ],
    targets: [
        .target(
            name: "TezosKit",
            dependencies: [
                "BigInt",
                "PromiseKit",
                "Base58Swift",
                "MnemonicKit",
                "Sodium",
                "CryptoSwift",
                "secp256k1",
                "DTTJailbreakDetection"
            ],
            path: "TezosKit"
        )
    ]
)
