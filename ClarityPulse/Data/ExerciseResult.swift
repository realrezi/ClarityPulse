import Foundation
import SwiftData

@Model
final class ExerciseResult {
    var id: UUID
    var exerciseType: String
    var accuracyPercentage: Double
    var averageReactionTimeMS: Double
    var tags: [String]?
    
    // Optional backlink
    var session: UserSession?
    
    init(id: UUID = UUID(), exerciseType: String, accuracyPercentage: Double, averageReactionTimeMS: Double, tags: [String]? = nil, session: UserSession? = nil) {
        self.id = id
        self.exerciseType = exerciseType
        self.accuracyPercentage = accuracyPercentage
        self.averageReactionTimeMS = averageReactionTimeMS
        self.tags = tags
        self.session = session
    }
}
