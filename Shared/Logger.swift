//
//  Logger.swift
//

import Foundation
import os

extension Logger {
  private static let subsystem = Bundle.main.bundleIdentifier!
  #if os(watchOS)
    static let shared = Logger(
      subsystem: subsystem,
      category: "SimpleWatchConnectivity"
    )
  #else
    static let shared = Logger(
      subsystem: subsystem,
      category: "SimpleWatchConnectivity"
    )
  #endif

  internal func debug(
    _ message: @autoclosure () -> String,
    _ file: String = #file,
    _ function: String = #function,
    line: Int = #line
  ) {
    // todo add thread?
    let converted =
      (file as NSString).lastPathComponent + ": " + function + ": "
      + "\(message())"
    self.debug(_:)("\(converted)")
  }
}
