//
//  SupplyListView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import SwiftData
import SwiftUI

struct SupplyListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SupplyItem.name) private var supplies: [SupplyItem]
    @State private var isShowingSupplyForm = false

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
                    List {
                        ForEach(supplies) { supply in
                            NavigationLink {
                                SupplyDetailView(supply: supply)
                            } label: {
                                SupplyRowView(
                                    name: supply.name,
                                    categoryName: supply.category.name,
                                    statusText: statusText(for: supply)
                                )
                            }
                        }
                        .onDelete(perform: deleteSupplies)
                    }
                }
            }
            .navigationTitle("Supplies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSupplyForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingSupplyForm) {
                SupplyFormView()
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
        DateStatusFormatter.supplyListQuantityStatusText(for: supply)
    }

    private func replacementStatusText(for supply: SupplyItem) -> String {
        DateStatusFormatter.replacementStatusText(
            for: supply,
            dueSoonUsesShortDate: true,
            expiredRelativePresentation: .named
        )
    }

    private func deleteSupplies(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(supplies[offset])
        }
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
