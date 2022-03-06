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
                "LTXiOSUtilsCoreExtension",
                "LTXiOSUtilsCoreUtil",
                "LTXiOSUtilsUtil",
                "LTXiOSUtilsPropertyWrapper",
                "LTXiOSUtilsNetwork",
            ]
        ),
        .library(name: "LTXiOSUtilsCoreExtension", type: .static, targets: ["LTXiOSUtilsCoreExtension"]),
        .library(name: "LTXiOSUtilsCoreUtil", type: .static, targets: ["LTXiOSUtilsCoreUtil"]),
        .library(name: "LTXiOSUtilsUtil", type: .static, targets: ["LTXiOSUtilsUtil"]),
        .library(name: "LTXiOSUtilsPropertyWrapper", type: .static, targets: ["LTXiOSUtilsPropertyWrapper"]),
        .library(name: "LTXiOSUtilsNetwork", type: .static, targets: ["LTXiOSUtilsNetwork"]),
    ],
    dependencies: [
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .exact("5.4.3")),
    ],
    targets: [
        .target(
            name: "LTXiOSUtilsCoreExtension",
            path: "Sources/LTXiOSUtils/Classes/Core/Extension"
        ),
        .target(
            name: "LTXiOSUtilsCoreUtil",
            path: "Sources/LTXiOSUtils/Classes/Core/CoreUtil"
        ),
        .target(
            name: "LTXiOSUtilsUtil",
            path: "Sources/LTXiOSUtils/Classes/Util"
        ),
        .target(
            name: "LTXiOSUtilsPropertyWrapper",
            path: "Sources/LTXiOSUtils/Classes/PropertyWrapper"
        ),
        .target(
            name: "LTXiOSUtilsNetwork",
            dependencies: ["Alamofire"],
            path: "Sources/LTXiOSUtils/Classes/Network"
        ),
    ]
)
