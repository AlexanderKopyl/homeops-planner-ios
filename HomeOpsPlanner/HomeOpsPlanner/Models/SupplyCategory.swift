import SwiftData

@Model
final class SupplyCategory {
    var name: String
    var note: String?

    init(name: String, note: String? = nil) {
        self.name = name
        self.note = note
    }
}
