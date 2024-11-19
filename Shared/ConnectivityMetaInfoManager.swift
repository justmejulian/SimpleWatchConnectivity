//
//  OpenConnectionManager.swift
//
//

import Foundation
import os

@MainActor
class ConnectivityMetaInfoManager: ObservableObject {
  @Published
  var openSendConnectionsCount = 0

  var hasOpenSendConnections: Bool {
    openSendConnectionsCount > 0
  }

  @Published
  var lastDidReceiveDataDate: Date?
}

extension ConnectivityMetaInfoManager {
  func reset() {
    openSendConnectionsCount = 0
  }

  func increaseOpenSendConnectionsCount() {
    openSendConnectionsCount += 1
  }

  func decreaseOpenSendConnectionsCount() {
    openSendConnectionsCount -= 1
  }

  func updateLastDidReceiveDataDate() {
    Logger.shared.debug("called on Thread \(Thread.current)")

    lastDidReceiveDataDate = Date()
  }
}
