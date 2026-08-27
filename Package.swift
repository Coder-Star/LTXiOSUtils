// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LTXiOSUtils",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "LTXiOSUtils",
            targets: [
                "LTXiOSUtils",
            ]
        ),
        .library(name: "LTXiOSUtilsExtension", type: .static, targets: ["LTXiOSUtilsExtension"]),
        .library(name: "LTXiOSUtilsUtil", type: .static, targets: ["LTXiOSUtilsUtil"]),
        .library(name: "LTXiOSUtilsPropertyWrapper", type: .static, targets: ["LTXiOSUtilsPropertyWrapper"]),
        .library(name: "LTXiOSUtilsComponent", type: .static, targets: ["LTXiOSUtilsComponent"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "LTXiOSUtils",
            dependencies: [
                "LTXiOSUtilsExtension",
                "LTXiOSUtilsUtil",
                "LTXiOSUtilsPropertyWrapper",
                "LTXiOSUtilsComponent",
            ],
            path: "Sources/LTXiOSUtils/Package"
        ),
        .target(
            name: "LTXiOSUtilsExtension",
            path: "Sources/LTXiOSUtils/Classes/Extension"
        ),
        .target(
            name: "LTXiOSUtilsUtil",
            dependencies: ["NCRuntimeUtils"],
            path: "Sources/LTXiOSUtils/Classes/Util"
        ),
        .target(
            name: "LTXiOSUtilsPropertyWrapper",
            path: "Sources/LTXiOSUtils/Classes/PropertyWrapper"
        ),
        .target(
            name: "LTXiOSUtilsComponent",
            dependencies: [
                "LTXiOSUtilsExtension",
                "LTXiOSUtilsUtil",
            ],
            path: "Sources/LTXiOSUtils/Classes/Component",
            resources: [
                .process("Resources/Resource"),
            ]
        ),
        .target(
            name: "NCRuntimeUtils",
            path: "Sources/LTXiOSUtils/Classes/NCRuntimeUtils",
            publicHeadersPath: "."
        ),
    ]
)
