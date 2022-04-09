// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LTXiOSUtils",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "LTXiOSUtils",
            targets: [
                "LTXiOSUtilsExtension",
                "LTXiOSUtilsUtil",
                "LTXiOSUtilsPropertyWrapper",
            ]
        ),
        .library(name: "LTXiOSUtilsExtension", type: .static, targets: ["LTXiOSUtilsExtension"]),
        .library(name: "LTXiOSUtilsUtil", type: .static, targets: ["LTXiOSUtilsUtil"]),
        .library(name: "LTXiOSUtilsPropertyWrapper", type: .static, targets: ["LTXiOSUtilsPropertyWrapper"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "LTXiOSUtilsExtension",
            path: "Sources/LTXiOSUtils/Classes/Extension"
        ),
        .target(
            name: "LTXiOSUtilsUtil",
            path: "Sources/LTXiOSUtils/Classes/Util"
        ),
        .target(
            name: "LTXiOSUtilsPropertyWrapper",
            path: "Sources/LTXiOSUtils/Classes/PropertyWrapper"
        ),
    ]
)
