//
//  ConnectivityManager.swift
//

import Foundation
import WatchConnectivity
import os

extension ConnectivityManager {
  nonisolated func sessionWatchStateDidChange(_ session: WCSession) {
    Logger.shared.debug("Session WatchState Did Change")
  }

  nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
    Logger.shared.debug("Session Did Become Inactive")
  }
  nonisolated func sessionDidDeactivate(_ session: WCSession) {
    Logger.shared.debug("Session Did Become Deactivate")
  }
}
