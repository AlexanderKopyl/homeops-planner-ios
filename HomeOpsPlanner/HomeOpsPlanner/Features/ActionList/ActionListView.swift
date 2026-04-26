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
                    id: actionID(sourceType: "supply", sourceID: sourceID(for: supply), reason: "expired"),
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
                    id: actionID(sourceType: "maintenance", sourceID: sourceID(for: task), reason: "overdue"),
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
                    id: actionID(sourceType: "supply", sourceID: sourceID(for: supply), reason: "low-stock"),
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
                    id: actionID(sourceType: "supply", sourceID: sourceID(for: supply), reason: "due-soon"),
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
                    id: actionID(sourceType: "maintenance", sourceID: sourceID(for: task), reason: "due-soon"),
                    title: task.title,
                    reason: maintenanceText(for: task),
                    sourceType: "Maintenance"
                )
            }
    }

    private func quantityText(for supply: SupplyItem) -> String {
        DateStatusFormatter.quantityLeftText(
            quantity: supply.currentQuantity,
            unitLabel: supply.unitLabel,
            missingText: "Low stock"
        )
    }

    private func replacementText(for supply: SupplyItem) -> String {
        DateStatusFormatter.replacementStatusText(
            for: supply,
            missingTextForState: { $0.isExpired ? "Expired" : "Due soon" }
        )
    }

    private func maintenanceText(for task: MaintenanceTask) -> String {
        DateStatusFormatter.maintenanceStatusText(for: task)
    }

    private func actionID(sourceType: String, sourceID: String, reason: String) -> String {
        "\(sourceType):\(sourceID):\(reason)"
    }

    private func sourceID(for supply: SupplyItem) -> String {
        String(describing: supply.persistentModelID)
    }

    private func sourceID(for task: MaintenanceTask) -> String {
        String(describing: task.persistentModelID)
    }
}

private struct DisplayAction: Identifiable {
    let id: String
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
