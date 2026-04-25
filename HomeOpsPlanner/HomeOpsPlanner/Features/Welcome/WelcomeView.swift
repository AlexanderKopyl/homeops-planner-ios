//
//  WelcomeView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 25.04.2026.
//

import SwiftUI

struct WelcomeView: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "house.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.tint)

                Text("HomeOps Planner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Keep household supplies, maintenance, contacts, and pending actions in one local-first place.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 16) {
                BenefitRow(text: "See what is running low soon.")
                BenefitRow(text: "Track maintenance that needs attention.")
                BenefitRow(text: "Keep preferred stores and service contacts easy to find.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            Button(action: onComplete) {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(24)
    }
}

private struct BenefitRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.tint)

            Text(text)
                .foregroundStyle(.primary)
        }
        .font(.body)
    }
}

#Preview {
    WelcomeView {}
}
