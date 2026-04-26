//
//  SupplyDetailView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import SwiftData
import SwiftUI

struct SupplyDetailView: View {
    let supply: SupplyItem

    var body: some View {
        Form {
            Section("Basics") {
                LabeledContent("Name", value: supply.name)
                LabeledContent("Category", value: supply.category.name)
                LabeledContent("Tracking", value: trackingTypeText)
                LabeledContent("Status", value: statusText)
            }

            if supply.trackingType == .quantity {
                quantitySection
            } else {
                dateSection
            }

            if let notes = trimmedNotes {
                Section("Notes") {
                    Text(notes)
                }
            }
        }
        .navigationTitle(supply.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var quantitySection: some View {
        Section("Quantity") {
            LabeledContent("Current quantity", value: quantityText)
            LabeledContent("Low-stock threshold", value: thresholdText)

            if let unitLabel = trimmedUnitLabel {
                LabeledContent("Unit", value: unitLabel)
            }

            HStack {
                Button("Use 1") {
                    useOne()
                }
                .disabled((supply.currentQuantity ?? 0) == 0)

                Spacer()

                Button("Add 1") {
                    addOne()
                }
            }
        }
    }

    private var dateSection: some View {
        Section("Dates") {
            if let startDate = supply.startDate {
                LabeledContent("Start date", value: dateText(for: startDate))
            }

            if let endDate = supply.endDate {
                LabeledContent("Replacement date", value: dateText(for: endDate))
            }

            if supply.startDate == nil && supply.endDate == nil {
                Text("No replacement dates set")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var trackingTypeText: String {
        switch supply.trackingType {
        case .quantity:
            return "Quantity"
        case .time:
            return "Time"
        }
    }

    private var statusText: String {
        switch supply.trackingType {
        case .quantity:
            return quantityStatusText
        case .time:
            return timeStatusText
        }
    }

    private var quantityStatusText: String {
        guard supply.currentQuantity != nil else {
            return "Quantity not set"
        }

        if supply.isLowStock {
            return "Low stock"
        }

        return "In stock"
    }

    private var timeStatusText: String {
        guard supply.endDate != nil else {
            return "Replacement date not set"
        }

        if supply.isExpired {
            return "Expired"
        }

        if supply.isDueSoon {
            return "Due soon"
        }

        return "Active"
    }

    private var quantityText: String {
        guard let currentQuantity = supply.currentQuantity else {
            return "Not set"
        }

        if let unitLabel = trimmedUnitLabel {
            return "\(currentQuantity) \(unitLabel)"
        }

        return "\(currentQuantity)"
    }

    private var thresholdText: String {
        guard let lowStockThreshold = supply.lowStockThreshold else {
            return "Not set"
        }

        if let unitLabel = trimmedUnitLabel {
            return "\(lowStockThreshold) \(unitLabel)"
        }

        return "\(lowStockThreshold)"
    }

    private var trimmedUnitLabel: String? {
        optionalTrimmedText(supply.unitLabel)
    }

    private var trimmedNotes: String? {
        optionalTrimmedText(supply.notes)
    }

    private func useOne() {
        let currentQuantity = supply.currentQuantity ?? 0
        supply.currentQuantity = max(currentQuantity - 1, 0)
    }

    private func addOne() {
        let currentQuantity = supply.currentQuantity ?? 0
        supply.currentQuantity = currentQuantity + 1
    }

    private func dateText(for date: Date) -> String {
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    private func optionalTrimmedText(_ text: String?) -> String? {
        guard let text else {
            return nil
        }

        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.isEmpty ? nil : trimmedText
    }
}

#Preview {
    let category = SupplyCategory(name: "Kitchen")
    let supply = SupplyItem(
        name: "Dishwasher tablets",
        category: category,
        trackingType: .quantity,
        notes: "Buy the fragrance-free pack.",
        currentQuantity: 3,
        lowStockThreshold: 5,
        unitLabel: "tablets"
    )

    NavigationStack {
        SupplyDetailView(supply: supply)
    }
    .modelContainer(for: [
        SupplyCategory.self,
        SupplyItem.self
    ])
}
