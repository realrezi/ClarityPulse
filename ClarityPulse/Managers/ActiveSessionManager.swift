import Foundation
import Observation

@Observable
final class ActiveSessionManager {
    // Strictly primitive types to prevent iOS 18 "dirty memory" terminations
    var currentExerciseType: String = ""
    var accuracyPercentage: Double = 0.0
    var averageReactionTimeMS: Double = 0.0
    var durationSeconds: Int = 0
    var selectedTags: [String]? = nil
    
    init() {}
    
    func reset() {
        currentExerciseType = ""
        accuracyPercentage = 0.0
        averageReactionTimeMS = 0.0
        durationSeconds = 0
    }
    
    func evaluatePerformance(recentAccuracies: [Double]) {
        guard recentAccuracies.count >= 3 else { return }
        
        let last3 = Array(recentAccuracies.prefix(3))
        let avgAccuracy = last3.reduce(0, +) / 3.0
        
        var currentLevel = UserDefaults.standard.integer(forKey: "currentNBackLevel")
        if currentLevel == 0 { currentLevel = 2 }
        
        if avgAccuracy >= 85.0 {
            currentLevel += 1
        } else if avgAccuracy <= 60.0 && currentLevel > 2 {
            currentLevel -= 1
        }
        
        UserDefaults.standard.set(currentLevel, forKey: "currentNBackLevel")
    }
}
