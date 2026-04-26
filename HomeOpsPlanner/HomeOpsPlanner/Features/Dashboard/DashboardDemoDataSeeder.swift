//
//  DashboardDemoDataSeeder.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

#if DEBUG
import Foundation
import SwiftData

enum DashboardDemoDataSeeder {
    // Temporary development-only seed action for manual Dashboard verification.
    static func seedDemoData(
        modelContext: ModelContext,
        supplies: [SupplyItem],
        maintenanceTasks: [MaintenanceTask],
        supplyCategories: [SupplyCategory]
    ) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let kitchenCategory = existingKitchenCategory(in: supplyCategories)
            ?? createKitchenCategory(modelContext: modelContext)

        insertSupplyIfMissing(
            named: "Demo Dishwasher tablets",
            category: kitchenCategory,
            trackingType: .quantity,
            currentQuantity: 3,
            lowStockThreshold: 5,
            unitLabel: "tablets",
            supplies: supplies,
            modelContext: modelContext
        )

        insertSupplyIfMissing(
            named: "Demo Expired water filter",
            category: kitchenCategory,
            trackingType: .time,
            startDate: calendar.date(byAdding: .month, value: -3, to: today),
            endDate: calendar.date(byAdding: .day, value: -1, to: today),
            supplies: supplies,
            modelContext: modelContext
        )

        insertSupplyIfMissing(
            named: "Demo Fridge deodorizer",
            category: kitchenCategory,
            trackingType: .time,
            startDate: calendar.date(byAdding: .month, value: -1, to: today),
            endDate: calendar.date(byAdding: .day, value: 3, to: today),
            supplies: supplies,
            modelContext: modelContext
        )

        insertMaintenanceTaskIfMissing(
            titled: "Demo Clean range hood filter",
            nextDueDate: calendar.date(byAdding: .day, value: -2, to: today) ?? today,
            frequencyNote: "Monthly",
            maintenanceTasks: maintenanceTasks,
            modelContext: modelContext
        )

        insertMaintenanceTaskIfMissing(
            titled: "Demo Check smoke detectors",
            nextDueDate: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
            frequencyNote: "Monthly",
            maintenanceTasks: maintenanceTasks,
            modelContext: modelContext
        )

        try? modelContext.save()
    }

    private static func existingKitchenCategory(in supplyCategories: [SupplyCategory]) -> SupplyCategory? {
        supplyCategories.first { $0.name == "Kitchen" }
    }

    private static func createKitchenCategory(modelContext: ModelContext) -> SupplyCategory {
        let category = SupplyCategory(name: "Kitchen")
        modelContext.insert(category)
        return category
    }

    private static func insertSupplyIfMissing(
        named name: String,
        category: SupplyCategory,
        trackingType: SupplyTrackingType,
        currentQuantity: Int? = nil,
        lowStockThreshold: Int? = nil,
        unitLabel: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        supplies: [SupplyItem],
        modelContext: ModelContext
    ) {
        guard !supplies.contains(where: { $0.name == name }) else {
            return
        }

        let supply = SupplyItem(
            name: name,
            category: category,
            trackingType: trackingType,
            currentQuantity: currentQuantity,
            lowStockThreshold: lowStockThreshold,
            unitLabel: unitLabel,
            startDate: startDate,
            endDate: endDate
        )
        modelContext.insert(supply)
    }

    private static func insertMaintenanceTaskIfMissing(
        titled title: String,
        nextDueDate: Date,
        frequencyNote: String,
        maintenanceTasks: [MaintenanceTask],
        modelContext: ModelContext
    ) {
        guard !maintenanceTasks.contains(where: { $0.title == title }) else {
            return
        }

        let task = MaintenanceTask(
            title: title,
            nextDueDate: nextDueDate,
            frequencyNote: frequencyNote
        )
        modelContext.insert(task)
    }
}
#endif
