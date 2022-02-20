// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LTXiOSUtils",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "LTXiOSUtils",
            targets: [
                "LTXiOSUtilsCoreExtension",
                "LTXiOSUtilsCoreUtil",
                "LTXiOSUtilsUtil",
            ]
        ),
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
    ]
)
