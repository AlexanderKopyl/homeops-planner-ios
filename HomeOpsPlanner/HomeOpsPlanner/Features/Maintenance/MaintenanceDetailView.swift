//
//  MaintenanceDetailView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import SwiftData
import SwiftUI

struct MaintenanceDetailView: View {
    let task: MaintenanceTask
    @State private var isShowingEditForm = false

    var body: some View {
        Form {
            Section("Basics") {
                LabeledContent("Title", value: task.title)
                LabeledContent("Next due date", value: dateText(for: task.nextDueDate))
                LabeledContent("Status", value: statusText)
            }

            if let lastCompletedDate = task.lastCompletedDate {
                Section("Completion") {
                    LabeledContent("Last completed", value: dateText(for: lastCompletedDate))
                }
            }

            if hasDetails {
                Section("Details") {
                    if let frequencyNote = trimmedFrequencyNote {
                        LabeledContent("Frequency", value: frequencyNote)
                    }

                    if let providerName = trimmedProviderName {
                        LabeledContent("Provider", value: providerName)
                    }
                }
            }

            if let notes = trimmedNotes {
                Section("Notes") {
                    Text(notes)
                }
            }

            Section {
                Button("Mark Completed Today") {
                    markCompletedToday()
                }
            }
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isShowingEditForm = true
                }
            }
        }
        .sheet(isPresented: $isShowingEditForm) {
            MaintenanceFormView(task: task)
        }
    }

    private var statusText: String {
        DateStatusFormatter.maintenanceStatusText(
            for: task,
            dueSoonPrefix: "Due soon",
            futureUsesShortDate: true
        )
    }

    private var hasDetails: Bool {
        trimmedFrequencyNote != nil || trimmedProviderName != nil
    }

    private var trimmedFrequencyNote: String? {
        optionalTrimmedText(task.frequencyNote)
    }

    private var trimmedProviderName: String? {
        optionalTrimmedText(task.providerName)
    }

    private var trimmedNotes: String? {
        optionalTrimmedText(task.notes)
    }

    private func markCompletedToday() {
        task.lastCompletedDate = Date()
        // Automatic recurrence rescheduling is postponed for a later V1 slice.
    }

    private func dateText(for date: Date) -> String {
        DateStatusFormatter.shortDateText(for: date)
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
    let task = MaintenanceTask(
        title: "Clean AC filters",
        nextDueDate: Date(),
        frequencyNote: "Every 3 months",
        providerName: "Home Service Co.",
        notes: "Check both bedroom units."
    )

    NavigationStack {
        MaintenanceDetailView(task: task)
    }
    .modelContainer(for: MaintenanceTask.self)
}
