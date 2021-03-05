// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "PasteboardPublisher",
	platforms: [.macOS(.v10_15)],
	products: [
		.library(
			name: "PasteboardPublisher",
			targets: ["PasteboardPublisher"]),
	],
	targets: [
		.target(
			name: "PasteboardPublisher",
			dependencies: []),
		.testTarget(
			name: "PasteboardPublisherTests",
			dependencies: ["PasteboardPublisher"]),
	]
)
