//
//  RootView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 25.04.2026.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome = false

    var body: some View {
        if hasCompletedWelcome {
            ContentView()
        } else {
            WelcomeView {
                hasCompletedWelcome = true
            }
        }
    }
}

#Preview {
    RootView()
}
