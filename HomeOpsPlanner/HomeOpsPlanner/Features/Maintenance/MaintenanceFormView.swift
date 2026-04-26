//
//  MaintenanceFormView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import SwiftData
import SwiftUI

struct MaintenanceFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var nextDueDate = Date()
    @State private var frequencyNote = ""
    @State private var providerName = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Title", text: $title)

                    DatePicker(
                        "Next due date",
                        selection: $nextDueDate,
                        displayedComponents: .date
                    )
                }

                Section("Details") {
                    TextField("Frequency note (optional)", text: $frequencyNote)
                    TextField("Provider name (optional)", text: $providerName)
                }

                Section("Notes") {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Maintenance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        !trimmedTitle.isEmpty
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedFrequencyNote: String? {
        optionalTrimmedText(frequencyNote)
    }

    private var trimmedProviderName: String? {
        optionalTrimmedText(providerName)
    }

    private var trimmedNotes: String? {
        optionalTrimmedText(notes)
    }

    private func saveTask() {
        let task = MaintenanceTask(
            title: trimmedTitle,
            nextDueDate: nextDueDate,
            frequencyNote: trimmedFrequencyNote,
            providerName: trimmedProviderName,
            notes: trimmedNotes
        )

        modelContext.insert(task)
        dismiss()
    }

    private func optionalTrimmedText(_ text: String) -> String? {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.isEmpty ? nil : trimmedText
    }
}

#Preview {
    MaintenanceFormView()
        .modelContainer(for: MaintenanceTask.self)
}
