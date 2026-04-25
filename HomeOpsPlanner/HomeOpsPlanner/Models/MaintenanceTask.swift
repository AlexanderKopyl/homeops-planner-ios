import Foundation
import SwiftData

@Model
final class MaintenanceTask {
    var title: String
    var nextDueDate: Date
    var lastCompletedDate: Date?
    var frequencyNote: String?
    var providerName: String?
    var notes: String?

    var isOverdue: Bool {
        nextDueDate < Date()
    }

    var isDueSoon: Bool {
        guard !isOverdue,
              let dueSoonLimit = Calendar.current.date(byAdding: .day, value: 7, to: Date()) else {
            return false
        }

        return nextDueDate <= dueSoonLimit
    }

    var needsAction: Bool {
        isOverdue || isDueSoon
    }

    init(
        title: String,
        nextDueDate: Date,
        lastCompletedDate: Date? = nil,
        frequencyNote: String? = nil,
        providerName: String? = nil,
        notes: String? = nil
    ) {
        self.title = title
        self.nextDueDate = nextDueDate
        self.lastCompletedDate = lastCompletedDate
        self.frequencyNote = frequencyNote
        self.providerName = providerName
        self.notes = notes
    }
}
