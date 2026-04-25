//
//  DashboardComponents.swift
//  HomeOpsPlanner
//
//  Created by Codex on 25.04.2026.
//

import SwiftUI

struct DashboardHeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DashboardSummaryView: View {
    let lowStockCount: Int
    let dueSoonCount: Int
    let overdueCount: Int

    var body: some View {
        HStack(spacing: 12) {
            DashboardSummaryCard(
                title: "Low stock",
                count: lowStockCount,
                statusText: "items"
            )

            DashboardSummaryCard(
                title: "Due soon",
                count: dueSoonCount,
                statusText: "items"
            )

            DashboardSummaryCard(
                title: "Overdue",
                count: overdueCount,
                statusText: "task"
            )
        }
    }
}

struct DashboardSummaryCard: View {
    let title: String
    let count: Int
    let statusText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("\(count)")
                .font(.title2)
                .fontWeight(.semibold)

            Text(statusText)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        }
    }
}

struct DashboardSectionView<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 0) {
                content
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.quaternary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DashboardItemRowView: View {
    let title: String
    let subtitle: String
    let statusText: String?

    init(
        title: String,
        subtitle: String,
        statusText: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.statusText = statusText
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            if let statusText {
                Text(statusText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Dashboard components") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            DashboardHeaderView(
                title: "HomeOps",
                subtitle: "Today, Apr 25"
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
            }
        }
        .padding()
    }
}
