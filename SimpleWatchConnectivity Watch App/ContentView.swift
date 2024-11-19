//
//  ContentView.swift
//  SimpleWatchConnectivity Watch App
//

import SwiftUI

struct ContentView: View {
  @ObservedObject
  private var connectivityMetaInfoManager: ConnectivityMetaInfoManager

  private let connectivityManager: ConnectivityManager

  init() {
    let connectivityMetaInfoManager = ConnectivityMetaInfoManager()
    self.connectivityManager = ConnectivityManager(
      connectivityMetaInfoManager: connectivityMetaInfoManager
    )
    self.connectivityMetaInfoManager = connectivityMetaInfoManager
  }

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("# of open Connections: \(connectivityMetaInfoManager.openSendConnectionsCount)")
      Button("Send Message") {
        Task.detached {
          try await connectivityManager.sendExample()
        }
      }
    }
    .padding()
  }
}
