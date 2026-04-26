//
//  SupplyFormView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import SwiftData
import SwiftUI

struct SupplyFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \SupplyCategory.name) private var categories: [SupplyCategory]

    @State private var name = ""
    @State private var selectedCategory: SupplyCategory?
    @State private var trackingType = SupplyTrackingType.quantity
    @State private var currentQuantity = ""
    @State private var lowStockThreshold = ""
    @State private var unitLabel = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Name", text: $name)

                    if categories.isEmpty {
                        Text("Create a category first.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Category", selection: $selectedCategory) {
                            Text("Select category")
                                .tag(nil as SupplyCategory?)

                            ForEach(categories) { category in
                                Text(category.name)
                                    .tag(category as SupplyCategory?)
                            }
                        }
                    }

                    Picker("Tracking type", selection: $trackingType) {
                        Text("Quantity")
                            .tag(SupplyTrackingType.quantity)
                        Text("Time")
                            .tag(SupplyTrackingType.time)
                    }
                    .pickerStyle(.segmented)
                }

                if trackingType == .quantity {
                    Section("Quantity") {
                        TextField("Current quantity", text: $currentQuantity)
                            .keyboardType(.numberPad)

                        TextField("Low-stock threshold", text: $lowStockThreshold)
                            .keyboardType(.numberPad)

                        TextField("Unit label (optional)", text: $unitLabel)
                    }
                } else {
                    Section("Dates") {
                        DatePicker(
                            "Start date",
                            selection: $startDate,
                            displayedComponents: .date
                        )

                        DatePicker(
                            "End date",
                            selection: $endDate,
                            displayedComponents: .date
                        )
                    }
                }

                Section("Notes") {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Supply")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSupply()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        guard !trimmedName.isEmpty,
              selectedCategory != nil else {
            return false
        }

        switch trackingType {
        case .quantity:
            return parsedCurrentQuantity != nil && parsedLowStockThreshold != nil
        case .time:
            return endDate >= startDate
        }
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedUnitLabel: String? {
        optionalTrimmedText(unitLabel)
    }

    private var trimmedNotes: String? {
        optionalTrimmedText(notes)
    }

    private var parsedCurrentQuantity: Int? {
        nonNegativeInteger(from: currentQuantity)
    }

    private var parsedLowStockThreshold: Int? {
        nonNegativeInteger(from: lowStockThreshold)
    }

    private func saveSupply() {
        guard let selectedCategory else {
            return
        }

        let supply = SupplyItem(
            name: trimmedName,
            category: selectedCategory,
            trackingType: trackingType,
            notes: trimmedNotes,
            currentQuantity: trackingType == .quantity ? parsedCurrentQuantity : nil,
            lowStockThreshold: trackingType == .quantity ? parsedLowStockThreshold : nil,
            unitLabel: trackingType == .quantity ? trimmedUnitLabel : nil,
            startDate: trackingType == .time ? startDate : nil,
            endDate: trackingType == .time ? endDate : nil
        )

        modelContext.insert(supply)
        dismiss()
    }

    private func optionalTrimmedText(_ text: String) -> String? {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.isEmpty ? nil : trimmedText
    }

    private func nonNegativeInteger(from text: String) -> Int? {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Int(trimmedText), value >= 0 else {
            return nil
        }

        return value
    }
}

#Preview {
    SupplyFormView()
        .modelContainer(for: [
            SupplyCategory.self,
            SupplyItem.self
        ])
}
