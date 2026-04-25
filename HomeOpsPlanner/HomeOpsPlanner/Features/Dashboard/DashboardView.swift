//
//  DashboardView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 25.04.2026.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    DashboardHeaderView(
                        title: "HomeOps",
                        subtitle: "Today, \(Date.now.formatted(date: .abbreviated, time: .omitted))"
                    )

                    DashboardSummaryView(
                        lowStockCount: 3,
                        dueSoonCount: 2,
                        overdueCount: 1
                    )

                    DashboardSectionView(
                        title: "Needs Attention",
                        subtitle: "Highest-priority household items"
                    ) {
                        DashboardItemRowView(
                            title: "Dishwasher tablets",
                            subtitle: "3 left · Kitchen",
                            statusText: "Low"
                        )

                        Divider()
                            .padding(.leading, 14)

                        DashboardItemRowView(
                            title: "Water filter cartridge",
                            subtitle: "Replace today · Filters",
                            statusText: "Today"
                        )

                        Divider()
                            .padding(.leading, 14)

                        DashboardItemRowView(
                            title: "Boiler inspection",
                            subtitle: "Overdue by 4 days",
                            statusText: "Overdue"
                        )
                    }

                    DashboardSectionView(title: "Running Low") {
                        DashboardItemRowView(
                            title: "Dishwasher tablets",
                            subtitle: "3 left · Kitchen"
                        )

                        Divider()
                            .padding(.leading, 14)

                        DashboardItemRowView(
                            title: "AA batteries",
                            subtitle: "2 left · Utility drawer"
                        )
                    }

                    DashboardSectionView(title: "Due Soon") {
                        DashboardItemRowView(
                            title: "Toilet freshener",
                            subtitle: "Replace by May 2 · Bathroom"
                        )

                        Divider()
                            .padding(.leading, 14)

                        DashboardItemRowView(
                            title: "Fridge deodorizer",
                            subtitle: "Replace by May 6 · Kitchen"
                        )
                    }

                    DashboardSectionView(title: "Maintenance") {
                        DashboardItemRowView(
                            title: "Clean AC",
                            subtitle: "Due in 5 days"
                        )

                        Divider()
                            .padding(.leading, 14)

                        DashboardItemRowView(
                            title: "Check smoke detectors",
                            subtitle: "Due in 2 weeks"
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    DashboardView()
}
