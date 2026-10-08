// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "square_in_app_payments",
    // Required because the Objective-C target ships localized (.lproj) resources.
    defaultLocalization: "en",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(name: "square-in-app-payments", targets: ["square_in_app_payments"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Square In-App Payments native iOS SDK, distributed as binary XCFrameworks.
        // Provides the `SquareInAppPaymentsSDK` and `SquareBuyerVerificationSDK` products.
        .package(url: "https://github.com/square/in-app-payments-ios", exact: "1.6.7")
    ],
    targets: [
        // Objective-C bridge: owns the method channel and wraps the Square SDK.
        // SPM does not allow mixing Swift and Objective-C in one target, so all of
        // the Objective-C bridge code lives here, and the Swift entry point below
        // depends on it.
        .target(
            name: "square_in_app_payments_objc",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "SquareInAppPaymentsSDK", package: "in-app-payments-ios"),
                .product(name: "SquareBuyerVerificationSDK", package: "in-app-payments-ios")
            ],
            resources: [
                // Localized error strings loaded via SWIFTPM_MODULE_BUNDLE.
                .process("Assets")
            ]
        ),
        // Swift entry point Flutter registers (matches `pluginClass` in pubspec.yaml).
        .target(
            name: "square_in_app_payments",
            dependencies: [
                "square_in_app_payments_objc",
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "SquareInAppPaymentsSDK", package: "in-app-payments-ios"),
                .product(name: "SquareBuyerVerificationSDK", package: "in-app-payments-ios")
            ],
            resources: [
                // Privacy manifest describing the plugin's privacy impact. Bundling it
                // also prevents SPM from warning about an unhandled file in Sources. See
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
