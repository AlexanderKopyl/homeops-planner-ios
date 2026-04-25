//
//  SplashIntroView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 25.04.2026.
//

import SwiftUI

struct SplashIntroView<WelcomeContent: View>: View {
    let welcomeContent: WelcomeContent

    @State private var logoOpacity = 0.0
    @State private var logoScale = 0.5
    @State private var showWelcomeContent = false
    @State private var hasStartedIntro = false

    init(@ViewBuilder welcomeContent: () -> WelcomeContent) {
        self.welcomeContent = welcomeContent()
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            if showWelcomeContent {
                welcomeContent
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else {
                Image("WelcomeLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .opacity(logoOpacity)
                    .scaleEffect(logoScale)
                    .transition(.opacity)
            }
        }
        .task {
            await runIntroIfNeeded()
        }
    }

    @MainActor
    private func runIntroIfNeeded() async {
        guard !hasStartedIntro else { return }

        hasStartedIntro = true

        withAnimation(.spring(response: 1.0, dampingFraction: 0.82)) {
            logoOpacity = 1
            logoScale = 1
        }

        try? await Task.sleep(for: .milliseconds(1_400))

        withAnimation(.easeInOut(duration: 0.8)) {
            showWelcomeContent = true
        }
    }
}

#Preview {
    SplashIntroView {
        WelcomeView {}
    }
}
