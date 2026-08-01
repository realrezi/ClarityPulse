import re

# 1. Update SessionSummaryView.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/SessionSummaryView.swift', 'r') as f:
    session_summary = f.read()

new_session_summary = """import SwiftUI
import SwiftData

struct SessionSummaryView: View {
    let result: ExerciseResult
    let correctMatches: Int
    let onDone: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#DCEBDE"), Color(hex: "#E1EBF5")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("\\(result.exerciseType) Complete")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2C3E50"))
                    .padding(.top, 40)
                    .accessibilityAddTraits(.isHeader)
                
                VStack(spacing: 24) {
                    summaryCard(title: "Accuracy", value: String(format: "%.1f%%", result.accuracyPercentage), icon: "target")
                    summaryCard(title: "Correct Matches", value: "\\(correctMatches)", icon: "checkmark.circle.fill")
                    summaryCard(title: "Reaction Time", value: String(format: "%.0f ms", result.averageReactionTimeMS), icon: "bolt.fill")
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button(action: onDone) {
                    Text("Done")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2C3E50"))
                        .cornerRadius(16)
                }
                .accessibilityHint("Returns to the home screen.")
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
    
    private func summaryCard(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "#2C3E50"))
                .frame(width: 32)
            
            Text(title)
                .font(.headline)
                .foregroundColor(Color(hex: "#2C3E50"))
            
            Spacer()
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#2C3E50"))
        }
        .padding()
        .background(Color.white.opacity(0.6))
        .cornerRadius(16)
    }
}

#Preview {
    SessionSummaryView(
        result: ExerciseResult(exerciseType: "2-Back", accuracyPercentage: 85.5, averageReactionTimeMS: 450.0),
        correctMatches: 12,
        onDone: {}
    )
}
"""
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/SessionSummaryView.swift', 'w') as f:
    f.write(new_session_summary)

# 2. Update StroopExerciseView.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/StroopExerciseView.swift', 'r') as f:
    stroop = f.read()

stroop = re.sub(
    r'@State private var showSummary: Bool = false\s*@State private var finalAccuracy: Double = 0\.0\s*@State private var finalReactionTime: Double = 0\.0',
    '@State private var completedResult: ExerciseResult? = nil',
    stroop
)

stroop_sheet_old = """.fullScreenCover(isPresented: $showSummary) {
            SessionSummaryView(
                title: "Stroop Task",
                accuracy: finalAccuracy,
                correctMatches: correctAnswers,
                averageReactionTimeMS: finalReactionTime,
                onDone: {
                    dismiss()
                }
            )
        }"""
stroop_sheet_new = """.sheet(item: $completedResult) { result in
            SessionSummaryView(
                result: result,
                correctMatches: correctAnswers,
                onDone: {
                    completedResult = nil
                    dismiss()
                }
            )
        }"""
stroop = stroop.replace(stroop_sheet_old, stroop_sheet_new)

stroop_finish_old = """    private func finishExercise() {
        // Exact Double calculation to prevent truncation
        let accuracy = Double(correctAnswers) / Double(totalTrials) * 100.0
        let avgReactionTimeMS = totalAnswered > 0 ? (Double(totalReactionTimeNS) / Double(totalAnswered)) / 1_000_000.0 : 0.0
        
        // Populate final variables for the summary screen first
        finalAccuracy = accuracy
        finalReactionTime = avgReactionTimeMS
        
        sessionManager.currentExerciseType = "Stroop"
        sessionManager.accuracyPercentage = accuracy
        sessionManager.averageReactionTimeMS = avgReactionTimeMS
        let durationSeconds = Int(Double(totalReactionTimeNS) / 1_000_000_000.0)
        sessionManager.durationSeconds = durationSeconds
        
        totalSessionsCompleted += 1
        NotificationManager.shared.scheduleDailyReminder()
        
        let container = modelContext.container
        let exerciseType = sessionManager.currentExerciseType
        let acc = sessionManager.accuracyPercentage
        let reactionTime = sessionManager.averageReactionTimeMS
        let dur = sessionManager.durationSeconds
        let tags = sessionManager.selectedTags
        
        Task {
            let actor = DatabaseActor(modelContainer: container)
            do {
                try await actor.batchSaveSession(
                    exerciseType: exerciseType,
                    accuracyPercentage: acc,
                    averageReactionTimeMS: reactionTime,
                    durationSeconds: dur,
                    tags: tags
                )
            } catch {
                print("Failed to save session: \\(error)")
            }
        }
        
        // Present summary after all math and state updates are finalized
        DispatchQueue.main.async {
            showSummary = true
        }
    }"""
stroop_finish_new = """    private func finishExercise() {
        // Exact Double calculation to prevent truncation
        let accuracy = Double(correctAnswers) / Double(totalTrials) * 100.0
        let avgReactionTimeMS = totalAnswered > 0 ? (Double(totalReactionTimeNS) / Double(totalAnswered)) / 1_000_000.0 : 0.0
        
        sessionManager.currentExerciseType = "Stroop"
        sessionManager.accuracyPercentage = accuracy
        sessionManager.averageReactionTimeMS = avgReactionTimeMS
        let durationSeconds = Int(Double(totalReactionTimeNS) / 1_000_000_000.0)
        sessionManager.durationSeconds = durationSeconds
        
        totalSessionsCompleted += 1
        NotificationManager.shared.scheduleDailyReminder()
        
        let container = modelContext.container
        let exerciseType = sessionManager.currentExerciseType
        let acc = sessionManager.accuracyPercentage
        let reactionTime = sessionManager.averageReactionTimeMS
        let dur = sessionManager.durationSeconds
        let tags = sessionManager.selectedTags
        
        let result = ExerciseResult(
            exerciseType: exerciseType,
            accuracyPercentage: acc,
            averageReactionTimeMS: reactionTime,
            tags: tags
        )
        
        Task {
            let actor = DatabaseActor(modelContainer: container)
            do {
                try await actor.batchSaveSession(
                    exerciseType: exerciseType,
                    accuracyPercentage: acc,
                    averageReactionTimeMS: reactionTime,
                    durationSeconds: dur,
                    tags: tags
                )
            } catch {
                print("Failed to save session: \\(error)")
            }
        }
        
        DispatchQueue.main.async {
            self.completedResult = result
        }
    }"""
stroop = stroop.replace(stroop_finish_old, stroop_finish_new)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/StroopExerciseView.swift', 'w') as f:
    f.write(stroop)

# 3. Update NBackExerciseView.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/NBackExerciseView.swift', 'r') as f:
    nback = f.read()

nback = re.sub(
    r'@State private var showSummary: Bool = false[\s\S]*?@State private var finalNLevel: Int = 2',
    '@State private var completedResult: ExerciseResult? = nil',
    nback
)

nback_sheet_old = """.fullScreenCover(isPresented: $showSummary) {
            SessionSummaryView(
                title: "\\(finalNLevel)-Back",
                accuracy: finalAccuracy,
                correctMatches: correctAnswers,
                averageReactionTimeMS: finalReactionTime,
                onDone: {
                    dismiss()
                }
            )
        }"""
nback_sheet_new = """.sheet(item: $completedResult) { result in
            SessionSummaryView(
                result: result,
                correctMatches: correctAnswers,
                onDone: {
                    completedResult = nil
                    dismiss()
                }
            )
        }"""
nback = nback.replace(nback_sheet_old, nback_sheet_new)

nback_finish_old = """    private func finishExercise() {
        exerciseTask?.cancel()
        exerciseTask = nil
        hasStartedExercise = false
        
        // Exact Double calculation to prevent truncation
        let accuracy = Double(correctAnswers) / Double(totalTrials) * 100.0
        let avgReactionTimeMS = totalAnswered > 0 ? (Double(totalReactionTimeNS) / Double(totalAnswered)) / 1_000_000.0 : 0.0
        
        // Populate final variables for the summary screen first
        finalAccuracy = accuracy
        finalReactionTime = avgReactionTimeMS
        finalNLevel = currentNBackLevel
        
        sessionManager.currentExerciseType = "\\(currentNBackLevel)-Back"
        sessionManager.accuracyPercentage = accuracy
        sessionManager.averageReactionTimeMS = avgReactionTimeMS
        sessionManager.durationSeconds = totalTrials * 2
        
        totalSessionsCompleted += 1
        
        NotificationManager.shared.scheduleDailyReminder()
        
        let container = modelContext.container
        let exerciseType = sessionManager.currentExerciseType
        let acc = sessionManager.accuracyPercentage
        let reactionTime = sessionManager.averageReactionTimeMS
        let dur = sessionManager.durationSeconds
        let tags = sessionManager.selectedTags
        
        Task {
            let actor = DatabaseActor(modelContainer: container)
            do {
                try await actor.batchSaveSession(
                    exerciseType: exerciseType,
                    accuracyPercentage: acc,
                    averageReactionTimeMS: reactionTime,
                    durationSeconds: dur,
                    tags: tags
                )
            } catch {
                print("Failed to save session: \\(error)")
            }
        }
        
        let previousAccuracies = recentSessions.compactMap { $0.results?.first?.accuracyPercentage }
        let allAccuracies = [accuracy] + previousAccuracies
        sessionManager.evaluatePerformance(recentAccuracies: allAccuracies)
        
        // Present summary after all math and state updates are finalized
        DispatchQueue.main.async {
            showSummary = true
        }
    }"""
nback_finish_new = """    private func finishExercise() {
        exerciseTask?.cancel()
        exerciseTask = nil
        hasStartedExercise = false
        
        // Exact Double calculation to prevent truncation
        let accuracy = Double(correctAnswers) / Double(totalTrials) * 100.0
        let avgReactionTimeMS = totalAnswered > 0 ? (Double(totalReactionTimeNS) / Double(totalAnswered)) / 1_000_000.0 : 0.0
        
        sessionManager.currentExerciseType = "\\(currentNBackLevel)-Back"
        sessionManager.accuracyPercentage = accuracy
        sessionManager.averageReactionTimeMS = avgReactionTimeMS
        sessionManager.durationSeconds = totalTrials * 2
        
        totalSessionsCompleted += 1
        
        NotificationManager.shared.scheduleDailyReminder()
        
        let container = modelContext.container
        let exerciseType = sessionManager.currentExerciseType
        let acc = sessionManager.accuracyPercentage
        let reactionTime = sessionManager.averageReactionTimeMS
        let dur = sessionManager.durationSeconds
        let tags = sessionManager.selectedTags
        
        let result = ExerciseResult(
            exerciseType: exerciseType,
            accuracyPercentage: acc,
            averageReactionTimeMS: reactionTime,
            tags: tags
        )
        
        Task {
            let actor = DatabaseActor(modelContainer: container)
            do {
                try await actor.batchSaveSession(
                    exerciseType: exerciseType,
                    accuracyPercentage: acc,
                    averageReactionTimeMS: reactionTime,
                    durationSeconds: dur,
                    tags: tags
                )
            } catch {
                print("Failed to save session: \\(error)")
            }
        }
        
        let previousAccuracies = recentSessions.compactMap { $0.results?.first?.accuracyPercentage }
        let allAccuracies = [accuracy] + previousAccuracies
        sessionManager.evaluatePerformance(recentAccuracies: allAccuracies)
        
        DispatchQueue.main.async {
            self.completedResult = result
        }
    }"""
nback = nback.replace(nback_finish_old, nback_finish_new)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/NBackExerciseView.swift', 'w') as f:
    f.write(nback)

