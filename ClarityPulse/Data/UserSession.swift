import Foundation
import SwiftData

@Model
final class UserSession {
    var id: UUID
    var date: Date
    var durationSeconds: Int
    
    // CRITICAL: Must be Optional to avoid iOS 17/18 Observation bugs.
    @Relationship(deleteRule: .cascade) var results: [ExerciseResult]?
    
    init(id: UUID = UUID(), date: Date = Date(), durationSeconds: Int = 0, results: [ExerciseResult]? = nil) {
        self.id = id
        self.date = date
        self.durationSeconds = durationSeconds
        self.results = results
    }
}
