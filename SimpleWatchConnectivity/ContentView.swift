//
//  ContentView.swift
//  SimpleWatchConnectivity
//
//  Created by Julian Visser on 17.11.2024.
//

import SwiftUI

struct ContentView: View {
  private let connectivityMetaInfoManager: ConnectivityMetaInfoManager
  private let connectivityManager: ConnectivityManager

  init() {
    self.connectivityMetaInfoManager = ConnectivityMetaInfoManager()
    self.connectivityManager = ConnectivityManager(
      connectivityMetaInfoManager: connectivityMetaInfoManager
    )
  }

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
      Button("Send Message") {
        Task {
          try await connectivityManager.sendExample()
        }
      }
    }
    .padding()
  }
}
