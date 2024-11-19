//
//  ConnectivityManager.swift
//
//

import Foundation
import OSLog
import SwiftData
import SwiftUI
@preconcurrency import WatchConnectivity

actor ConnectivityManager: NSObject, WCSessionDelegate {

  private var session: WCSession = .default

  private let connectivityMetaInfoManager: ConnectivityMetaInfoManager

  init(connectivityMetaInfoManager: ConnectivityMetaInfoManager) {
    Logger.shared.debug("run on Thread \(Thread.current)")

    self.connectivityMetaInfoManager = connectivityMetaInfoManager

    super.init()

    self.session.delegate = self
    self.session.activate()
  }
}

extension ConnectivityManager {
  nonisolated func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    Logger.shared.debug("called on Thread \(Thread.current)")

    if let error = error {
      Logger.shared.error(
        "Error trying to activate WCSession: \(error.localizedDescription)"
      )
    } else {
      Logger.shared.info("The session has completed activation.")
    }
  }

  nonisolated func session(
    _ session: WCSession,
    didReceiveMessageData messageData: Data,
    replyHandler: @escaping @Sendable (Data) -> Void
  ) {
    Logger.shared.debug("called on Thread \(Thread.current)")

    Logger.shared.debug(
      "messageData: \(try! JSONDecoder().decode([String: String].self, from: messageData))"
    )
    Task {
      Logger.shared.debug("Task called on Thread \(Thread.current)")

      replyHandler(try! JSONEncoder().encode(["sucess": "reply"]))
    }
  }
}

// MARK: -  ConnectivityManager sendData
//
extension ConnectivityManager {
  func sendExample() async throws -> Data? {
    Logger.shared.debug("called on Thread \(Thread.current)")

    let reply = try await self.sendMessageData(
      try! JSONEncoder().encode(["sucess": "send"]))

    Logger.shared.debug(
      "reply: \(try! JSONDecoder().decode([String: String].self, from: reply!))"
    )

    return reply
  }

  private func sendMessageData(_ data: Data) async throws -> Data? {
    Logger.shared.debug("called on Thread \(Thread.current)")

    await connectivityMetaInfoManager.increaseOpenSendConnectionsCount()

    return try await withCheckedThrowingContinuation({
      continuation in
      Logger.shared.debug(
        "withCheckedThrowingContinuation called on Thread \(Thread.current)"
      )
      self.session.sendMessageData(
        data,
        replyHandler: { data in
          Logger.shared.debug(
            "replyHandler called on Thread \(Thread.current)")
          Task {
            await self.connectivityMetaInfoManager
              .decreaseOpenSendConnectionsCount()
          }
          continuation.resume(returning: data)
        },
        errorHandler: { (error) in
          Logger.shared.debug(
            "errorHandler called on Thread \(Thread.current)")
          Task {
            await self.connectivityMetaInfoManager
              .decreaseOpenSendConnectionsCount()
          }
          continuation.resume(throwing: error)
        }
      )
    })
  }
}
