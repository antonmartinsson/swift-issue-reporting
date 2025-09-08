// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "swift-issue-reporting",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "IssueReporting", targets: ["IssueReporting"]),
  ],
  targets: [
    .target(name: "IssueReporting"),
  ],
  swiftLanguageModes: [.v6]
)
