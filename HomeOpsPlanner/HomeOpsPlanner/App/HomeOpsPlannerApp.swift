//
//  HomeOpsPlannerApp.swift
//  HomeOpsPlanner
//
//  Created by Александр Копыл on 25.04.2026.
//

import SwiftUI
import SwiftData

@main
struct HomeOpsPlannerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: [
                    SupplyCategory.self,
                    SupplyItem.self,
                    MaintenanceTask.self
                ])
        }
    }
}
