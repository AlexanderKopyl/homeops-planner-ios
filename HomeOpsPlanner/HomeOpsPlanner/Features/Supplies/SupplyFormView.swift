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

    private let supply: SupplyItem?

    @State private var name = ""
    @State private var selectedCategory: SupplyCategory?
    @State private var newCategoryName = ""
    @State private var trackingType = SupplyTrackingType.quantity
    @State private var currentQuantity = ""
    @State private var lowStockThreshold = ""
    @State private var unitLabel = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes = ""

    init(supply: SupplyItem? = nil) {
        self.supply = supply

        _name = State(initialValue: supply?.name ?? "")
        _selectedCategory = State(initialValue: supply?.category)
        _trackingType = State(initialValue: supply?.trackingType ?? .quantity)
        _currentQuantity = State(initialValue: supply?.currentQuantity.map(String.init) ?? "")
        _lowStockThreshold = State(initialValue: supply?.lowStockThreshold.map(String.init) ?? "")
        _unitLabel = State(initialValue: supply?.unitLabel ?? "")
        _startDate = State(initialValue: supply?.startDate ?? Date())
        _endDate = State(initialValue: supply?.endDate ?? Date())
        _notes = State(initialValue: supply?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Name", text: $name)

                    if categories.isEmpty {
                        Text("Add a category to continue.")
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

                    TextField("New category name", text: $newCategoryName)

                    Button("Add Category") {
                        addCategory()
                    }
                    .disabled(trimmedNewCategoryName.isEmpty)

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
            .navigationTitle(navigationTitle)
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

    private var navigationTitle: String {
        supply == nil ? "New Supply" : "Edit Supply"
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

    private var trimmedNewCategoryName: String {
        newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
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

    private func addCategory() {
        let categoryName = trimmedNewCategoryName
        guard !categoryName.isEmpty else {
            return
        }

        if let existingCategory = categories.first(where: { category in
            category.name.compare(
                categoryName,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) == .orderedSame
        }) {
            selectedCategory = existingCategory
            newCategoryName = ""
            return
        }

        let category = SupplyCategory(name: categoryName)
        modelContext.insert(category)
        selectedCategory = category
        newCategoryName = ""
    }

    private func saveSupply() {
        guard let selectedCategory else {
            return
        }

        if let supply {
            update(supply, category: selectedCategory)
        } else {
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
        }

        dismiss()
    }

    private func update(_ supply: SupplyItem, category: SupplyCategory) {
        supply.name = trimmedName
        supply.category = category
        supply.trackingType = trackingType
        supply.notes = trimmedNotes

        if trackingType == .quantity {
            supply.currentQuantity = parsedCurrentQuantity
            supply.lowStockThreshold = parsedLowStockThreshold
            supply.unitLabel = trimmedUnitLabel
            supply.startDate = nil
            supply.endDate = nil
        } else {
            supply.currentQuantity = nil
            supply.lowStockThreshold = nil
            supply.unitLabel = nil
            supply.startDate = startDate
            supply.endDate = endDate
        }
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
