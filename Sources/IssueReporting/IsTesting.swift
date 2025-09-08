#if os(WASI)
public let isTesting = false
#else
import Foundation

/// Whether the current process is running under a test harness.
///
/// This inspects environment variables and process arguments commonly used by
/// XCTest and SwiftPM's test runner.
public let isTesting = ProcessInfo.processInfo.isTesting

extension ProcessInfo {
  fileprivate var isTesting: Bool {
    if environment.keys.contains("XCTestBundlePath") { return true }
    if environment.keys.contains("XCTestConfigurationFilePath") { return true }
    if environment.keys.contains("XCTestSessionIdentifier") { return true }

    return arguments.contains { argument in
      let path = URL(fileURLWithPath: argument)
      return path.lastPathComponent == "swiftpm-testing-helper"
        || argument == "--testing-library"
        || path.lastPathComponent == "xctest"
        || path.pathExtension == "xctest"
    }
  }
}
#endif
