import Foundation
#if canImport(Darwin)
import Darwin
#endif
#if canImport(os)
import os
#endif

/// Reports an issue that will appear as a purple runtime warning in Xcode.
public func reportIssue(
  _ message: @autoclosure () -> String? = nil,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) {
  RuntimeWarningReporter.shared.report(
    message(),
    fileID: fileID,
    filePath: filePath,
    line: line,
    column: column
  )
}

private struct RuntimeWarningReporter {
  static let shared = RuntimeWarningReporter()

  #if canImport(os)
  private let dso: UnsafeRawPointer = {
    let count = _dyld_image_count()
    for i in 0..<count {
      if let name = _dyld_get_image_name(i) {
        let swiftString = String(cString: name)
        if swiftString.hasSuffix("/SwiftUI"), let header = _dyld_get_image_header(i) {
          return UnsafeRawPointer(header)
        }
      }
    }
    return #dsohandle
  }()
  #endif

  func report(
    _ message: String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    #if canImport(os)
    guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else {
      print("🟣 \(fileID):\(line): \(message ?? "")")
      return
    }
    let moduleName = String("\(fileID)".split(separator: "/").first ?? "")
    var text = message ?? ""
    if text.isEmpty {
      text = "Issue reported"
    }
    os_log(
      .fault,
      dso: dso,
      log: OSLog(subsystem: "com.apple.runtime-issues", category: moduleName),
      "%@",
      text
    )
    #else
    let output = "\(fileID):\(line): \(message ?? "")\n"
    if let data = output.data(using: .utf8) {
      FileHandle.standardError.write(data)
    }
    #endif
  }
}

