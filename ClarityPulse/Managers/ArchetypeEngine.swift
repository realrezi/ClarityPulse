import Foundation

struct ArchetypeResult {
    let title: String
    let icon: String
    let description: String
}

struct ArchetypeEngine {
    static func calculate(results: [ExerciseResult]) -> ArchetypeResult? {
        let stroopResults = results.filter { $0.exerciseType == "Stroop" }
        
        guard stroopResults.count >= 5 else {
            return nil
        }
        
        let avgRT = stroopResults.reduce(0) { $0 + $1.averageReactionTimeMS } / Double(stroopResults.count)
        let avgAcc = stroopResults.reduce(0) { $0 + $1.accuracyPercentage } / Double(stroopResults.count)
        
        if avgRT < 700.0 && avgAcc < 80.0 {
            return ArchetypeResult(title: "The Sprinter", icon: "bolt.fill", description: "Blistering speed, prone to impulse.")
        } else if avgRT > 900.0 && avgAcc > 90.0 {
            return ArchetypeResult(title: "The Sniper", icon: "scope", description: "Highly accurate, methodical processing.")
        } else {
            return ArchetypeResult(title: "The Metronome", icon: "metronome.fill", description: "Perfectly balanced speed and accuracy.")
        }
    }
}
