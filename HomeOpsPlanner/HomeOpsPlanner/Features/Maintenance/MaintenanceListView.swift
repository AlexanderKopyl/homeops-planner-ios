//
//  MaintenanceListView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import SwiftData
import SwiftUI

struct MaintenanceListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MaintenanceTask.nextDueDate) private var tasks: [MaintenanceTask]
    @State private var isShowingMaintenanceForm = false

    var body: some View {
        NavigationStack {
            Group {
                if tasks.isEmpty {
                    ContentUnavailableView(
                        "No maintenance tasks yet",
                        systemImage: "wrench.and.screwdriver",
                        description: Text("Add recurring home maintenance tasks to track what is due or overdue.")
                    )
                } else {
                    List {
                        ForEach(tasks) { task in
                            NavigationLink {
                                MaintenanceDetailView(task: task)
                            } label: {
                                MaintenanceRowView(
                                    title: task.title,
                                    statusText: statusText(for: task),
                                    frequencyNote: task.frequencyNote,
                                    providerName: task.providerName
                                )
                            }
                        }
                        .onDelete(perform: deleteTasks)
                    }
                }
            }
            .navigationTitle("Maintenance")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingMaintenanceForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingMaintenanceForm) {
                MaintenanceFormView()
            }
        }
    }

    private func statusText(for task: MaintenanceTask) -> String {
        if task.isOverdue {
            return "Overdue \(relativeDateText(for: task.nextDueDate))"
        }

        if Calendar.current.isDateInToday(task.nextDueDate) {
            return "Due today"
        }

        if task.isDueSoon {
            return "Due soon \(relativeDateText(for: task.nextDueDate))"
        }

        return "Due \(task.nextDueDate.formatted(date: .abbreviated, time: .omitted))"
    }

    private func relativeDateText(for date: Date) -> String {
        date.formatted(.relative(presentation: .numeric, unitsStyle: .wide))
    }

    private func deleteTasks(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(tasks[offset])
        }
    }
}

private struct MaintenanceRowView: View {
    let title: String
    let statusText: String
    let frequencyNote: String?
    let providerName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.body)

            Text(rowDetails)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var rowDetails: String {
        ([statusText] + optionalDetails).joined(separator: " · ")
    }

    private var optionalDetails: [String] {
        [frequencyNote, providerName].compactMap { detail in
            guard let detail, !detail.isEmpty else {
                return nil
            }

            return detail
        }
    }
}

#Preview {
    MaintenanceListView()
        .modelContainer(for: MaintenanceTask.self)
}
