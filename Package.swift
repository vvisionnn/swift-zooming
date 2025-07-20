// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Zooming",
	platforms: [.iOS(.v16)],
	products: [
		.library(
			name: "Zooming",
			targets: ["Zooming"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0")
	],
	targets: [
		.target(
			name: "Zooming",
			path: "Sources/Zooming",
			swiftSettings: [
				.enableUpcomingFeature("BareSlashRegexLiterals"),
				.enableUpcomingFeature("ConciseMagicFile"),
				.enableUpcomingFeature("ForwardTrailingClosures"),
				.enableUpcomingFeature("ImplicitOpenExistentials"),
				.enableUpcomingFeature("StrictConcurrency")
			]
		),
		.testTarget(
			name: "ZoomingTests",
			dependencies: [
				"Zooming",
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing")
			],
			path: "Tests/ZoomingTests"
		)
	]
)
