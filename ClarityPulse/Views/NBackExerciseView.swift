import SwiftUI
import SwiftData
import Combine

struct NBackExerciseView: View {
    @Environment(ActiveSessionManager.self) private var sessionManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("hasSeenNBackInstructions") private var hasSeenInstructions: Bool = false
    @AppStorage("currentNBackLevel") private var currentNBackLevel: Int = 2
    
    @Query(sort: \UserSession.date, order: .reverse) private var recentSessions: [UserSession]
    
    @State private var showingInstructions: Bool = false
    @State private var hasStartedExercise: Bool = false
        @State private var showSummary: Bool = false
    
    private let totalTrials = 20
    private let possibleSymbols = ["star.fill", "circle.fill", "square.fill", "triangle.fill", "heart.fill", "moon.fill"]
    
    @State private var currentTrial = 0
    @State private var symbolHistory: [String] = []
    @State private var currentSymbol: String = "questionmark.circle"
    @State private var correctAnswers = 0
    @State private var totalAnswered = 0
    @State private var totalReactionTimeNS: UInt64 = 0
    
    @State private var exerciseTask: Task<Void, Never>?
    @State private var isSymbolVisible: Bool = true
    @State private var stimulusAppearanceTime: UInt64 = 0
    
    @State private var triggerFeedback: Bool = false
    @State private var isLastCorrect: Bool = false
    
    @State private var completedResult: ExerciseResult? = nil
    
    @AppStorage("totalSessionsCompleted") private var totalSessionsCompleted: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    pauseExercise()
                    showingInstructions = true
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                }
                .accessibilityLabel("Help")
                .accessibilityHint("Shows the instructions for the \(currentNBackLevel)-Back exercise.")
            }
            
            Text("\(currentNBackLevel)-Back Exercise")
                .font(.largeTitle)
                .fontWeight(.bold)
                .minimumScaleFactor(0.8)
                .accessibilityAddTraits(.isHeader)
            
            Text("Trial \(currentTrial)/\(totalTrials)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if isSymbolVisible {
                Image(systemName: currentSymbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.blue)
                    .transition(.opacity)
                    .id(currentTrial)
                    .accessibilityLabel("Shape: \(currentSymbol.replacingOccurrences(of: ".fill", with: ""))")
            } else {
                // Placeholder to maintain spacing
                Color.clear
                    .frame(width: 150, height: 150)
            }
            
            Spacer()
            
            Button(action: handleMatchTap) {
                Text("Match!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(16)
            }
            .accessibilityHint("Tap to indicate the current shape matches the one shown \(currentNBackLevel) steps ago.")
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingInstructions, onDismiss: {
            hasSeenInstructions = true
            resumeOrStartExercise()
        }) {
            NBackInstructionsView()
        }
        .sheet(item: $completedResult) { result in
            SessionSummaryView(
                result: result,
                correctMatches: correctAnswers,
                onDone: {
                    completedResult = nil
                    dismiss()
                }
            )
        }
        .onAppear {
            if !hasSeenInstructions {
                showingInstructions = true
            } else {
                resumeOrStartExercise()
            }
        }
        .onDisappear {
            exerciseTask?.cancel()
        }
    }
    
    private func pauseExercise() {
        exerciseTask?.cancel()
        exerciseTask = nil
    }
    
    private func resumeOrStartExercise() {
        if !hasStartedExercise {
            startExercise()
        } else if exerciseTask == nil {
            exerciseTask = Task { await runExerciseLoop() }
        }
    }
    
    private func startExercise() {
        sessionManager.reset()
        currentTrial = 0
        correctAnswers = 0
        totalAnswered = 0
        totalReactionTimeNS = 0
        symbolHistory.removeAll()
        hasStartedExercise = true
        
        exerciseTask = Task { await runExerciseLoop() }
    }
    
    @MainActor
    private func runExerciseLoop() async {
        while currentTrial < totalTrials && !Task.isCancelled {
            nextStimulus()
            
            withAnimation(.easeInOut(duration: 0.15)) {
                isSymbolVisible = true
            }
            
            do {
                try await Task.sleep(nanoseconds: 1_500_000_000)
            } catch {
                break
            }
            
            if Task.isCancelled { break }
            
            withAnimation(.easeInOut(duration: 0.15)) {
                isSymbolVisible = false
            }
            stimulusAppearanceTime = 0
            
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                break
            }
        }
        
        if currentTrial >= totalTrials && !Task.isCancelled {
            finishExercise()
        }
    }
    
    private func nextStimulus() {
        let newSymbol: String
        if symbolHistory.count >= currentNBackLevel && Double.random(in: 0...1) < 0.3 {
            newSymbol = symbolHistory[symbolHistory.count - currentNBackLevel]
        } else {
            newSymbol = possibleSymbols.randomElement() ?? "star.fill"
        }
        
        symbolHistory.append(newSymbol)
        currentSymbol = newSymbol
        stimulusAppearanceTime = DispatchTime.now().uptimeNanoseconds
        currentTrial += 1
    }
    
    private func handleMatchTap() {
        guard stimulusAppearanceTime != 0 else { return }
        
        HapticManager.playLightImpact()
        
        let reactionTime = DispatchTime.now().uptimeNanoseconds - stimulusAppearanceTime
        stimulusAppearanceTime = 0
        
        let isMatch = symbolHistory.count > currentNBackLevel && symbolHistory.last == symbolHistory[symbolHistory.count - 1 - currentNBackLevel]
        
        if isMatch {
            HapticManager.playSuccess()
            correctAnswers += 1
        } else {
            HapticManager.playError()
        }
        
        totalAnswered += 1
        totalReactionTimeNS += reactionTime
    }
    
    private func finishExercise() {
        exerciseTask?.cancel()
        exerciseTask = nil
        hasStartedExercise = false
        
        // Exact Double calculation to prevent truncation
        let accuracy = Double(correctAnswers) / Double(totalTrials) * 100.0
        let avgReactionTimeMS = totalAnswered > 0 ? (Double(totalReactionTimeNS) / Double(totalAnswered)) / 1_000_000.0 : 0.0
        
        sessionManager.currentExerciseType = "\(currentNBackLevel)-Back"
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
                print("Failed to save session: \(error)")
            }
        }
        
        let previousAccuracies = recentSessions.compactMap { $0.results?.first?.accuracyPercentage }
        let allAccuracies = [accuracy] + previousAccuracies
        sessionManager.evaluatePerformance(recentAccuracies: allAccuracies)
        
        DispatchQueue.main.async {
            self.completedResult = result
        }
    }
}

#Preview {
    NBackExerciseView()
        .environment(ActiveSessionManager())
}
