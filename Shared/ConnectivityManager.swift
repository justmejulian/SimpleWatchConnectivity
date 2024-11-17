//
//  ConnectivityManager.swift
//  tricorder
//
//  Created by Julian Visser on 07.11.2024.
//

import Foundation
import OSLog
import SwiftData
import SwiftUI
@preconcurrency import WatchConnectivity

actor ConnectivityManager: NSObject, WCSessionDelegate {

    private var session: WCSession = .default

    override init() {
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
        
        Logger.shared.debug("messageData: \(try! JSONDecoder().decode([String: String].self, from: messageData))")

        replyHandler(try! JSONEncoder().encode(["sucess": "reply"]))
    }
}

// MARK: -  ConnectivityManager sendData
//
extension ConnectivityManager {
    func sendExample() async throws -> Data? {
        Logger.shared.debug("called on Thread \(Thread.current)")

        let reply = try await sendMessageData(try! JSONEncoder().encode(["sucess": "send"]))
        
        guard let reply else {
            Logger.shared.error("Did not receive reply.")
            return nil
        }
        
        Logger.shared.debug("reply: \(try! JSONDecoder().decode([String: String].self, from: reply))")
        
        return reply
    }

    private func sendMessageData(_ data: Data) async throws -> Data? {
        return try await withCheckedThrowingContinuation({
            continuation in
            self.session.sendMessageData(
                data,
                replyHandler: { data in
                    Logger.shared.debug(
                        "connectivityManager.sendMessageData replyHandler called"
                    )
                    continuation.resume(returning: data)
                },
                errorHandler: { (error) in
                    Logger.shared.debug(
                        "connectivityManager.sendMessageData errorHandler called"
                    )
                    continuation.resume(throwing: error)
                }
            )
        })
    }
}
