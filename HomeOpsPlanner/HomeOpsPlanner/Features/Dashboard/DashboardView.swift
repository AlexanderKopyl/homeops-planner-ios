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
    @State private var isShowingSupplyForm = false
    @State private var isShowingMaintenanceForm = false

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
                        subtitle: "Today, \(DateStatusFormatter.shortDateText(for: Date.now))"
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
                        DashboardEmptyStateView(
                            onAddSupply: {
                                isShowingSupplyForm = true
                            },
                            onAddMaintenance: {
                                isShowingMaintenanceForm = true
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $isShowingSupplyForm) {
                SupplyFormView()
            }
            .sheet(isPresented: $isShowingMaintenanceForm) {
                MaintenanceFormView()
            }
            #if DEBUG
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Seed Demo Data") {
                        DashboardDemoDataSeeder.seedDemoData(
                            modelContext: modelContext,
                            supplies: supplies,
                            maintenanceTasks: maintenanceTasks,
                            supplyCategories: supplyCategories
                        )
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
            NavigationLink {
                SupplyDetailView(supply: item)
            } label: {
                DashboardItemRowView(
                    title: item.name,
                    subtitle: supplySubtitle(for: item),
                    statusText: showStatus ? supplyStatusText(for: item) : nil
                )
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private func maintenanceRows(_ tasks: [MaintenanceTask], showStatus: Bool = false) -> some View {
        ForEach(tasks.indices, id: \.self) { index in
            if index > tasks.startIndex {
                rowDivider()
            }

            let task = tasks[index]
            NavigationLink {
                MaintenanceDetailView(task: task)
            } label: {
                DashboardItemRowView(
                    title: task.title,
                    subtitle: maintenanceSubtitle(for: task),
                    statusText: showStatus ? maintenanceStatusText(for: task) : nil
                )
            }
            .buttonStyle(.plain)
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
        DateStatusFormatter.quantityLeftText(
            quantity: item.currentQuantity,
            unitLabel: item.unitLabel
        )
    }

    private func replacementText(for item: SupplyItem) -> String {
        DateStatusFormatter.replacementStatusText(for: item)
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
        DateStatusFormatter.maintenanceStatusText(for: task)
    }

    private func maintenanceStatusText(for task: MaintenanceTask) -> String {
        task.isOverdue ? "Overdue" : "Soon"
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [
            SupplyCategory.self,
            SupplyItem.self,
            MaintenanceTask.self
        ])
}
