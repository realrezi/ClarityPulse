import Foundation
import SwiftData

@ModelActor
actor DatabaseActor {
    
    func batchSaveSession(
        exerciseType: String,
        accuracyPercentage: Double,
        averageReactionTimeMS: Double,
        durationSeconds: Int,
        tags: [String]? = nil
    ) async throws {
        // Create the session
        let newSession = UserSession(
            date: Date(),
            durationSeconds: durationSeconds
        )
        
        // Create the result and link it to the session
        let newResult = ExerciseResult(
            exerciseType: exerciseType,
            accuracyPercentage: accuracyPercentage,
            averageReactionTimeMS: averageReactionTimeMS,
            tags: tags,
            session: newSession
        )
        
        // Populate the relationship
        newSession.results = [newResult]
        
        // Insert into context
        modelContext.insert(newSession)
        modelContext.insert(newResult)
        
        // Save the context
        try modelContext.save()
    }
}
