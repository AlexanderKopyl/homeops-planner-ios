//
//  SupplyListView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import SwiftData
import SwiftUI

struct SupplyListView: View {
    @Query(sort: \SupplyItem.name) private var supplies: [SupplyItem]

    var body: some View {
        NavigationStack {
            Group {
                if supplies.isEmpty {
                    ContentUnavailableView(
                        "No supplies yet",
                        systemImage: "shippingbox",
                        description: Text("Add household supplies to track what runs low or needs replacement.")
                    )
                } else {
                    List(supplies) { supply in
                        SupplyRowView(
                            name: supply.name,
                            categoryName: supply.category.name,
                            statusText: statusText(for: supply)
                        )
                    }
                }
            }
            .navigationTitle("Supplies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Present the supply create form when that MVP slice exists.
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(true)
                }
            }
        }
    }

    private func statusText(for supply: SupplyItem) -> String {
        switch supply.trackingType {
        case .quantity:
            return quantityStatusText(for: supply)
        case .time:
            return replacementStatusText(for: supply)
        }
    }

    private func quantityStatusText(for supply: SupplyItem) -> String {
        guard let currentQuantity = supply.currentQuantity else {
            return "Quantity not set"
        }

        let quantityText: String
        if let unitLabel = supply.unitLabel, !unitLabel.isEmpty {
            quantityText = "\(currentQuantity) \(unitLabel) left"
        } else {
            quantityText = "\(currentQuantity) left"
        }

        if supply.isLowStock {
            return "\(quantityText) · Low stock"
        }

        if let lowStockThreshold = supply.lowStockThreshold {
            return "\(quantityText) · Low at \(lowStockThreshold)"
        }

        return quantityText
    }

    private func replacementStatusText(for supply: SupplyItem) -> String {
        guard let endDate = supply.endDate else {
            return "Replacement date not set"
        }

        if Calendar.current.isDateInToday(endDate) {
            return "Replace today"
        }

        if supply.isExpired {
            return "Expired \(relativeDateText(for: endDate))"
        }

        if supply.isDueSoon {
            return "Replace soon · \(endDate.formatted(date: .abbreviated, time: .omitted))"
        }

        return "Replace by \(endDate.formatted(date: .abbreviated, time: .omitted))"
    }

    private func relativeDateText(for date: Date) -> String {
        date.formatted(.relative(presentation: .named, unitsStyle: .wide))
    }
}

private struct SupplyRowView: View {
    let name: String
    let categoryName: String
    let statusText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.body)

            Text("\(categoryName) · \(statusText)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SupplyListView()
        .modelContainer(for: [
            SupplyCategory.self,
            SupplyItem.self
        ])
}
