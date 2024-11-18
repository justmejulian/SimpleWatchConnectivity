//
//  ContentView.swift
//  SimpleWatchConnectivity Watch App
//
//  Created by Julian Visser on 17.11.2024.
//

import SwiftUI

struct ContentView: View {
  private let connectivityManager = ConnectivityManager()

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
      Button("Send Message") {
        Task.detached {
          try await connectivityManager.sendExample()
        }
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
