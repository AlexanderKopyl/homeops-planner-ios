//
//  MainTabView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 25.04.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }

            PlaceholderTabView(title: "Supplies", systemImage: "shippingbox")
                .tabItem {
                    Label("Supplies", systemImage: "shippingbox")
                }

            PlaceholderTabView(title: "Maintenance", systemImage: "wrench.and.screwdriver")
                .tabItem {
                    Label("Maintenance", systemImage: "wrench.and.screwdriver")
                }

            PlaceholderTabView(title: "Actions", systemImage: "checklist")
                .tabItem {
                    Label("Actions", systemImage: "checklist")
                }
        }
    }
}

private struct PlaceholderTabView: View {
    let title: String
    let systemImage: String

    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                title,
                systemImage: systemImage,
                description: Text("This area will be added in a future MVP step.")
            )
            .navigationTitle(title)
        }
    }
}

#Preview {
    MainTabView()
}
