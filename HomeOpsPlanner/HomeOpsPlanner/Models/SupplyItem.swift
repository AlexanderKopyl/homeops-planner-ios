import Foundation
import SwiftData

@Model
final class SupplyItem {
    var name: String
    var category: SupplyCategory
    var trackingTypeRawValue: String
    var preferredMerchantName: String?
    var preferredMerchantURL: String?
    var notes: String?
    var currentQuantity: Int?
    var lowStockThreshold: Int?
    var unitLabel: String?
    var startDate: Date?
    var endDate: Date?

    var trackingType: SupplyTrackingType {
        get {
            SupplyTrackingType(rawValue: trackingTypeRawValue) ?? .quantity
        }
        set {
            trackingTypeRawValue = newValue.rawValue
        }
    }

    var isLowStock: Bool {
        guard trackingType == .quantity,
              let currentQuantity,
              let lowStockThreshold else {
            return false
        }

        return currentQuantity <= lowStockThreshold
    }

    var isExpired: Bool {
        guard trackingType == .time,
              let endDate else {
            return false
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let endDay = calendar.startOfDay(for: endDate)

        return endDay < today
    }

    var isDueSoon: Bool {
        guard trackingType == .time,
              let endDate,
              !isExpired else {
            return false
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let dueSoonLimit = calendar.date(byAdding: .day, value: 7, to: today) else {
            return false
        }

        let endDay = calendar.startOfDay(for: endDate)
        return endDay <= dueSoonLimit
    }

    var needsAction: Bool {
        isLowStock || isExpired || isDueSoon
    }

    init(
        name: String,
        category: SupplyCategory,
        trackingType: SupplyTrackingType,
        preferredMerchantName: String? = nil,
        preferredMerchantURL: String? = nil,
        notes: String? = nil,
        currentQuantity: Int? = nil,
        lowStockThreshold: Int? = nil,
        unitLabel: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) {
        self.name = name
        self.category = category
        self.trackingTypeRawValue = trackingType.rawValue
        self.preferredMerchantName = preferredMerchantName
        self.preferredMerchantURL = preferredMerchantURL
        self.notes = notes
        self.currentQuantity = currentQuantity
        self.lowStockThreshold = lowStockThreshold
        self.unitLabel = unitLabel
        self.startDate = startDate
        self.endDate = endDate
    }
}
