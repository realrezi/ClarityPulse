import Foundation
import SwiftData

@Model
final class MicroTrial {
    var id: UUID = UUID()
    var title: String
    var tagA: String
    var tagB: String
    var startDate: Date
    var isActive: Bool
    
    init(id: UUID = UUID(), title: String, tagA: String, tagB: String, startDate: Date = Date(), isActive: Bool = true) {
        self.id = id
        self.title = title
        self.tagA = tagA
        self.tagB = tagB
        self.startDate = startDate
        self.isActive = isActive
    }
}
