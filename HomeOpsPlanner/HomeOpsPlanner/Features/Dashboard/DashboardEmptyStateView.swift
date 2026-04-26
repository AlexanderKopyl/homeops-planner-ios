//
//  DashboardEmptyStateView.swift
//  HomeOpsPlanner
//
//  Created by Codex on 25.04.2026.
//

import SwiftUI

struct DashboardEmptyStateView: View {
    let onAddSupply: () -> Void
    let onAddMaintenance: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your home is clear for now.")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Add supplies or maintenance tasks to start tracking what runs low, expires, or needs attention.")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                Button("Add Supply", action: onAddSupply)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)

                Button("Add Maintenance", action: onAddMaintenance)
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        }
    }
}

#Preview {
    DashboardEmptyStateView(
        onAddSupply: {},
        onAddMaintenance: {}
    )
        .padding()
}
