//
//  DateStatusFormatter.swift
//  HomeOpsPlanner
//
//  Created by Codex on 26.04.2026.
//

import Foundation

enum DateStatusFormatter {
    static func shortDateText(for date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    static func relativeDateText(
        for date: Date,
        presentation: Date.RelativeFormatStyle.Presentation = .numeric
    ) -> String {
        date.formatted(.relative(presentation: presentation, unitsStyle: .wide))
    }

    static func quantityLeftText(
        quantity: Int?,
        unitLabel: String?,
        missingText: String = "Quantity not set"
    ) -> String {
        guard let quantity else {
            return missingText
        }

        if let unitLabel, !unitLabel.isEmpty {
            return "\(quantity) \(unitLabel) left"
        }

        return "\(quantity) left"
    }

    static func supplyListQuantityStatusText(for supply: SupplyItem) -> String {
        let quantityText = quantityLeftText(
            quantity: supply.currentQuantity,
            unitLabel: supply.unitLabel
        )

        guard supply.currentQuantity != nil else {
            return quantityText
        }

        if supply.isLowStock {
            return "\(quantityText) · Low stock"
        }

        if let lowStockThreshold = supply.lowStockThreshold {
            return "\(quantityText) · Low at \(lowStockThreshold)"
        }

        return quantityText
    }

    static func supplyDetailQuantityStatusText(for supply: SupplyItem) -> String {
        guard supply.currentQuantity != nil else {
            return "Quantity not set"
        }

        return supply.isLowStock ? "Low stock" : "In stock"
    }

    static func replacementStatusText(
        for supply: SupplyItem,
        missingText: String = "Replacement date not set",
        missingTextForState: ((SupplyItem) -> String)? = nil,
        dueSoonUsesShortDate: Bool = false,
        expiredRelativePresentation: Date.RelativeFormatStyle.Presentation = .numeric
    ) -> String {
        guard let endDate = supply.endDate else {
            return missingTextForState?(supply) ?? missingText
        }

        if Calendar.current.isDateInToday(endDate) {
            return "Replace today"
        }

        if supply.isExpired {
            return "Expired \(relativeDateText(for: endDate, presentation: expiredRelativePresentation))"
        }

        if dueSoonUsesShortDate && supply.isDueSoon {
            return "Replace soon · \(shortDateText(for: endDate))"
        }

        return "Replace by \(shortDateText(for: endDate))"
    }

    static func supplyDetailTimeStatusText(for supply: SupplyItem) -> String {
        guard supply.endDate != nil else {
            return "Replacement date not set"
        }

        if supply.isExpired {
            return "Expired"
        }

        return supply.isDueSoon ? "Due soon" : "Active"
    }

    static func maintenanceStatusText(
        for task: MaintenanceTask,
        dueSoonPrefix: String = "Due",
        futureUsesShortDate: Bool = false
    ) -> String {
        if task.isOverdue {
            return "Overdue \(relativeDateText(for: task.nextDueDate))"
        }

        if Calendar.current.isDateInToday(task.nextDueDate) {
            return "Due today"
        }

        if task.isDueSoon {
            return "\(dueSoonPrefix) \(relativeDateText(for: task.nextDueDate))"
        }

        if futureUsesShortDate {
            return "Due \(shortDateText(for: task.nextDueDate))"
        }

        return "Due \(relativeDateText(for: task.nextDueDate))"
    }
}
