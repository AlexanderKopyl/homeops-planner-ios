//
//  ActionListView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import SwiftUI
import SwiftData

struct ActionListView: View {
    @Query(sort: \SupplyItem.name) private var supplies: [SupplyItem]
    @Query(sort: \MaintenanceTask.nextDueDate) private var maintenanceTasks: [MaintenanceTask]

    var body: some View {
        NavigationStack {
            Group {
                if actions.isEmpty {
                    ContentUnavailableView(
                        "No actions right now",
                        systemImage: "checklist",
                        description: Text("Supplies and maintenance tasks that need attention will appear here.")
                    )
                } else {
                    List(actions) { action in
                        ActionRowView(action: action)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Actions")
        }
    }

    private var actions: [DisplayAction] {
        expiredSupplyActions
            + overdueMaintenanceActions
            + lowStockSupplyActions
            + dueSoonSupplyActions
            + dueSoonMaintenanceActions
    }

    private var expiredSupplyActions: [DisplayAction] {
        supplies
            .filter(\.isExpired)
            .map { supply in
                DisplayAction(
                    title: supply.name,
                    reason: replacementText(for: supply),
                    sourceType: "Supply"
                )
            }
    }

    private var overdueMaintenanceActions: [DisplayAction] {
        maintenanceTasks
            .filter(\.isOverdue)
            .map { task in
                DisplayAction(
                    title: task.title,
                    reason: maintenanceText(for: task),
                    sourceType: "Maintenance"
                )
            }
    }

    private var lowStockSupplyActions: [DisplayAction] {
        supplies
            .filter(\.isLowStock)
            .map { supply in
                DisplayAction(
                    title: supply.name,
                    reason: quantityText(for: supply),
                    sourceType: "Supply"
                )
            }
    }

    private var dueSoonSupplyActions: [DisplayAction] {
        supplies
            .filter(\.isDueSoon)
            .map { supply in
                DisplayAction(
                    title: supply.name,
                    reason: replacementText(for: supply),
                    sourceType: "Supply"
                )
            }
    }

    private var dueSoonMaintenanceActions: [DisplayAction] {
        maintenanceTasks
            .filter(\.isDueSoon)
            .map { task in
                DisplayAction(
                    title: task.title,
                    reason: maintenanceText(for: task),
                    sourceType: "Maintenance"
                )
            }
    }

    private func quantityText(for supply: SupplyItem) -> String {
        guard let currentQuantity = supply.currentQuantity else {
            return "Low stock"
        }

        if let unitLabel = supply.unitLabel, !unitLabel.isEmpty {
            return "\(currentQuantity) \(unitLabel) left"
        }

        return "\(currentQuantity) left"
    }

    private func replacementText(for supply: SupplyItem) -> String {
        guard let endDate = supply.endDate else {
            return supply.isExpired ? "Expired" : "Due soon"
        }

        if Calendar.current.isDateInToday(endDate) {
            return "Replace today"
        }

        if supply.isExpired {
            return "Expired \(relativeDateText(for: endDate))"
        }

        return "Replace by \(endDate.formatted(date: .abbreviated, time: .omitted))"
    }

    private func maintenanceText(for task: MaintenanceTask) -> String {
        if task.isOverdue {
            return "Overdue \(relativeDateText(for: task.nextDueDate))"
        }

        if Calendar.current.isDateInToday(task.nextDueDate) {
            return "Due today"
        }

        return "Due \(relativeDateText(for: task.nextDueDate))"
    }

    private func relativeDateText(for date: Date) -> String {
        date.formatted(.relative(presentation: .numeric, unitsStyle: .wide))
    }
}

private struct DisplayAction: Identifiable {
    let id = UUID()
    let title: String
    let reason: String
    let sourceType: String
}

private struct ActionRowView: View {
    let action: DisplayAction

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(action.title)
                    .font(.headline)

                Text(action.reason)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            Text(action.sourceType)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.secondarySystemGroupedBackground), in: Capsule())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ActionListView()
        .modelContainer(for: [
            SupplyCategory.self,
            SupplyItem.self,
            MaintenanceTask.self
        ])
}
