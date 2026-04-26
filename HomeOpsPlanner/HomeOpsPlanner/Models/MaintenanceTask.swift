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
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dueDay = calendar.startOfDay(for: nextDueDate)

        return dueDay < today
    }

    var isDueSoon: Bool {
        guard !isOverdue else {
            return false
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let dueSoonLimit = calendar.date(byAdding: .day, value: 7, to: today) else {
            return false
        }

        let dueDay = calendar.startOfDay(for: nextDueDate)
        return dueDay <= dueSoonLimit
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
