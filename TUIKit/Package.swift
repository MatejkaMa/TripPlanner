// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TUIKit",
  platforms: [.iOS(.v15)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "TUIKit",
      type: .dynamic,
      targets: ["APIKit", "TUIAPIKit", "TUIAlgorithmKit"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "APIKit",
      dependencies: [],
      path: "APIKit",
      exclude: ["Tests"],
      sources: ["Sources"]
    ),
    .target(
      name: "TUIAPIKit",
      dependencies: [
        .target(name: "APIKit")
      ],
      path: "TUIAPIKit",
      exclude: ["Tests"],
      sources: ["Sources"],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "TUIAlgorithmKit",
      dependencies: [
        .target(name: "TUIAPIKit")
      ],
      path: "TUIAlgorithmKit",
      exclude: ["Tests"],
      sources: ["Sources"]
      //            resources: [
      //                .process("Resources")
      //            ]
    ),
    // Test targets
    .testTarget(
      name: "APIKitTests",
      dependencies: ["APIKit"],
      path: "APIKit/Tests"
    ),
    .testTarget(
      name: "TUIAPIKitTests",
      dependencies: ["TUIAPIKit"],
      path: "TUIAPIKit/Tests"
    ),
    .testTarget(
      name: "TUIAlgorithmKitTests",
      dependencies: ["TUIAlgorithmKit"],
      path: "TUIAlgorithmKit/Tests"
    ),
  ]
)
