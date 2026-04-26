//
//  DashboardView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 25.04.2026.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \SupplyItem.name) private var supplies: [SupplyItem]
    @Query(sort: \MaintenanceTask.nextDueDate) private var maintenanceTasks: [MaintenanceTask]

    #if DEBUG
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SupplyCategory.name) private var supplyCategories: [SupplyCategory]
    #endif

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    DashboardHeaderView(
                        title: "HomeOps",
                        subtitle: "Today, \(Date.now.formatted(date: .abbreviated, time: .omitted))"
                    )

                    if hasDashboardData {
                        DashboardSummaryView(
                            lowStockCount: runningLowSupplies.count,
                            dueSoonCount: dueSoonSupplies.count + dueSoonMaintenanceTasks.count,
                            overdueCount: expiredSupplies.count + overdueMaintenanceTasks.count
                        )

                        if hasNeedsAttentionItems {
                            DashboardSectionView(
                                title: "Needs Attention",
                                subtitle: "Highest-priority household items"
                            ) {
                                supplyRows(needsAttentionSupplies, showStatus: true)

                                if !needsAttentionSupplies.isEmpty && !needsAttentionMaintenanceTasks.isEmpty {
                                    rowDivider()
                                }

                                maintenanceRows(needsAttentionMaintenanceTasks, showStatus: true)
                            }
                        }

                        if !runningLowSupplies.isEmpty {
                            DashboardSectionView(title: "Running Low") {
                                supplyRows(runningLowSupplies)
                            }
                        }

                        if !dueSoonSupplies.isEmpty {
                            DashboardSectionView(title: "Due Soon") {
                                supplyRows(dueSoonSupplies)
                            }
                        }

                        if !maintenanceSectionTasks.isEmpty {
                            DashboardSectionView(title: "Maintenance") {
                                maintenanceRows(maintenanceSectionTasks)
                            }
                        }
                    } else {
                        DashboardEmptyStateView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            #if DEBUG
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Seed Demo Data") {
                        seedDemoData()
                    }
                }
            }
            #endif
        }
    }

    private var hasDashboardData: Bool {
        !supplies.isEmpty || !maintenanceTasks.isEmpty
    }

    private var runningLowSupplies: [SupplyItem] {
        supplies.filter(\.isLowStock)
    }

    private var dueSoonSupplies: [SupplyItem] {
        supplies.filter { $0.trackingType == .time && $0.isDueSoon }
    }

    private var expiredSupplies: [SupplyItem] {
        supplies.filter { $0.trackingType == .time && $0.isExpired }
    }

    private var overdueMaintenanceTasks: [MaintenanceTask] {
        maintenanceTasks.filter(\.isOverdue)
    }

    private var dueSoonMaintenanceTasks: [MaintenanceTask] {
        maintenanceTasks.filter(\.isDueSoon)
    }

    private var needsAttentionSupplies: [SupplyItem] {
        runningLowSupplies + expiredSupplies
    }

    private var needsAttentionMaintenanceTasks: [MaintenanceTask] {
        overdueMaintenanceTasks
    }

    private var hasNeedsAttentionItems: Bool {
        !needsAttentionSupplies.isEmpty || !needsAttentionMaintenanceTasks.isEmpty
    }

    private var maintenanceSectionTasks: [MaintenanceTask] {
        overdueMaintenanceTasks + dueSoonMaintenanceTasks
    }

    @ViewBuilder
    private func supplyRows(_ items: [SupplyItem], showStatus: Bool = false) -> some View {
        ForEach(items.indices, id: \.self) { index in
            if index > items.startIndex {
                rowDivider()
            }

            let item = items[index]
            DashboardItemRowView(
                title: item.name,
                subtitle: supplySubtitle(for: item),
                statusText: showStatus ? supplyStatusText(for: item) : nil
            )
        }
    }

    @ViewBuilder
    private func maintenanceRows(_ tasks: [MaintenanceTask], showStatus: Bool = false) -> some View {
        ForEach(tasks.indices, id: \.self) { index in
            if index > tasks.startIndex {
                rowDivider()
            }

            let task = tasks[index]
            DashboardItemRowView(
                title: task.title,
                subtitle: maintenanceSubtitle(for: task),
                statusText: showStatus ? maintenanceStatusText(for: task) : nil
            )
        }
    }

    private func rowDivider() -> some View {
        Divider()
            .padding(.leading, 14)
    }

    private func supplySubtitle(for item: SupplyItem) -> String {
        switch item.trackingType {
        case .quantity:
            return "\(quantityText(for: item)) · \(item.category.name)"
        case .time:
            return "\(replacementText(for: item)) · \(item.category.name)"
        }
    }

    private func quantityText(for item: SupplyItem) -> String {
        guard let currentQuantity = item.currentQuantity else {
            return "Quantity not set"
        }

        if let unitLabel = item.unitLabel, !unitLabel.isEmpty {
            return "\(currentQuantity) \(unitLabel) left"
        }

        return "\(currentQuantity) left"
    }

    private func replacementText(for item: SupplyItem) -> String {
        guard let endDate = item.endDate else {
            return "Replacement date not set"
        }

        if Calendar.current.isDateInToday(endDate) {
            return "Replace today"
        }

        if endDate < Date() {
            return "Expired \(relativeDateText(for: endDate))"
        }

        return "Replace by \(endDate.formatted(date: .abbreviated, time: .omitted))"
    }

    private func supplyStatusText(for item: SupplyItem) -> String {
        if item.isLowStock {
            return "Low"
        }

        if item.isExpired {
            return "Expired"
        }

        return "Soon"
    }

    private func maintenanceSubtitle(for task: MaintenanceTask) -> String {
        if task.isOverdue {
            return "Overdue \(relativeDateText(for: task.nextDueDate))"
        }

        if Calendar.current.isDateInToday(task.nextDueDate) {
            return "Due today"
        }

        return "Due \(relativeDateText(for: task.nextDueDate))"
    }

    private func maintenanceStatusText(for task: MaintenanceTask) -> String {
        task.isOverdue ? "Overdue" : "Soon"
    }

    private func relativeDateText(for date: Date) -> String {
        date.formatted(.relative(presentation: .numeric, unitsStyle: .wide))
    }

    #if DEBUG
    // Temporary development-only seed action for manual Dashboard verification.
    private func seedDemoData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let kitchenCategory = existingKitchenCategory() ?? createKitchenCategory()

        insertSupplyIfMissing(
            named: "Demo Dishwasher tablets",
            category: kitchenCategory,
            trackingType: .quantity,
            currentQuantity: 3,
            lowStockThreshold: 5,
            unitLabel: "tablets"
        )

        insertSupplyIfMissing(
            named: "Demo Expired water filter",
            category: kitchenCategory,
            trackingType: .time,
            startDate: calendar.date(byAdding: .month, value: -3, to: today),
            endDate: calendar.date(byAdding: .day, value: -1, to: today)
        )

        insertSupplyIfMissing(
            named: "Demo Fridge deodorizer",
            category: kitchenCategory,
            trackingType: .time,
            startDate: calendar.date(byAdding: .month, value: -1, to: today),
            endDate: calendar.date(byAdding: .day, value: 3, to: today)
        )

        insertMaintenanceTaskIfMissing(
            titled: "Demo Clean range hood filter",
            nextDueDate: calendar.date(byAdding: .day, value: -2, to: today) ?? today,
            frequencyNote: "Monthly"
        )

        insertMaintenanceTaskIfMissing(
            titled: "Demo Check smoke detectors",
            nextDueDate: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
            frequencyNote: "Monthly"
        )

        try? modelContext.save()
    }

    private func existingKitchenCategory() -> SupplyCategory? {
        supplyCategories.first { $0.name == "Kitchen" }
    }

    private func createKitchenCategory() -> SupplyCategory {
        let category = SupplyCategory(name: "Kitchen")
        modelContext.insert(category)
        return category
    }

    private func insertSupplyIfMissing(
        named name: String,
        category: SupplyCategory,
        trackingType: SupplyTrackingType,
        currentQuantity: Int? = nil,
        lowStockThreshold: Int? = nil,
        unitLabel: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil
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

    private func insertMaintenanceTaskIfMissing(
        titled title: String,
        nextDueDate: Date,
        frequencyNote: String
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
    #endif
}

#Preview {
    DashboardView()
        .modelContainer(for: [
            SupplyCategory.self,
            SupplyItem.self,
            MaintenanceTask.self
        ])
}
