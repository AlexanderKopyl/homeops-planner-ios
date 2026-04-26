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

            SupplyListView()
                .tabItem {
                    Label("Supplies", systemImage: "shippingbox")
                }

            MaintenanceListView()
                .tabItem {
                    Label("Maintenance", systemImage: "wrench.and.screwdriver")
                }

            ActionListView()
                .tabItem {
                    Label("Actions", systemImage: "checklist")
                }
        }
    }
}

#Preview {
    MainTabView()
}
