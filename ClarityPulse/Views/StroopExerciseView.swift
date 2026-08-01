import SwiftUI
import SwiftData

struct StroopExerciseView: View {
    @Environment(ActiveSessionManager.self) private var sessionManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentTrial = 1
    private let totalTrials = 20
    
    @State private var currentWordText = ""
    @State private var currentColor = Color.black
    @State private var correctColorName = ""
    
    @State private var correctAnswers = 0
    @State private var totalAnswered = 0
    @State private var totalReactionTimeNS: UInt64 = 0
    
    @State private var stimulusAppearanceTime: UInt64 = 0
    @State private var triggerFeedback = false
    @State private var isLastCorrect = false
    
    @State private var showSummary = false
    @State private var completedResult: ExerciseResult? = nil
    
    @AppStorage("totalSessionsCompleted") private var totalSessionsCompleted: Int = 0
    
    struct StroopColor: Hashable {
        let name: String
        let color: Color
    }
    
    private let stroopColors: [StroopColor] = [
        StroopColor(name: "RED", color: .red),
        StroopColor(name: "BLUE", color: .blue),
        StroopColor(name: "GREEN", color: .green),
        StroopColor(name: "YELLOW", color: .yellow),
        StroopColor(name: "ORANGE", color: .orange),
        StroopColor(name: "PURPLE", color: .purple)
    ]
    
    @State private var currentOptions: [StroopColor] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#DCEBDE"), Color(hex: "#E1EBF5")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(Color(hex: "#2C3E50").opacity(0.6))
                            .padding()
                    }
                    .accessibilityLabel("Close")
                    
                    Spacer()
                }
                
                Text("Stroop Task")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2C3E50"))
                    .accessibilityAddTraits(.isHeader)
                
                Text("Trial \(currentTrial)/\(totalTrials)")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#2C3E50").opacity(0.7))
                
                Spacer()
                
                if currentTrial <= totalTrials && !currentWordText.isEmpty {
                    Text(currentWordText)
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(currentColor)
                        .minimumScaleFactor(0.5)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(16)
                        .shadow(radius: 5)
                        .accessibilityLabel("Word says \(currentWordText), printed in \(correctColorName) color.")
                }
                
                Spacer()
                
                Text("Select the INK color:")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#2C3E50"))
                    .padding(.bottom, 8)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(currentOptions, id: \.name) { option in
                        Button(action: {
                            handleTap(on: option)
                        }) {
                            Text(option.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(option.color)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                        }
                        .accessibilityHint("Selects \(option.name)")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
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
            startExercise()
        }
    }
    
    private func startExercise() {
        sessionManager.reset()
        currentTrial = 1
        correctAnswers = 0
        totalAnswered = 0
        totalReactionTimeNS = 0
        
        generateStimulus()
    }
    
    private func generateStimulus() {
        let wordOption = stroopColors.randomElement()!
        
        let colorOption: StroopColor
        if Double.random(in: 0...1) < 0.3 {
            colorOption = wordOption
        } else {
            var others = stroopColors
            others.removeAll { $0.name == wordOption.name }
            colorOption = others.randomElement()!
        }
        
        currentWordText = wordOption.name
        currentColor = colorOption.color
        correctColorName = colorOption.name
        
        var optionsPool = stroopColors
        optionsPool.removeAll { $0.name == colorOption.name }
        optionsPool.shuffle()
        
        var selectedOptions = Array(optionsPool.prefix(3))
        selectedOptions.append(colorOption)
        selectedOptions.shuffle()
        
        currentOptions = selectedOptions
        stimulusAppearanceTime = DispatchTime.now().uptimeNanoseconds
    }
    
    private func handleTap(on tappedOption: StroopColor) {
        guard stimulusAppearanceTime != 0 else { return }
        
        HapticManager.playLightImpact()
        
        let reactionTime = DispatchTime.now().uptimeNanoseconds - stimulusAppearanceTime
        stimulusAppearanceTime = 0
        
        let isMatch = (tappedOption.name == correctColorName)
        
        if isMatch {
            HapticManager.playSuccess()
            correctAnswers += 1
        } else {
            HapticManager.playError()
        }
        
        totalAnswered += 1
        totalReactionTimeNS += reactionTime
        
        if currentTrial >= totalTrials {
            finishExercise()
        } else {
            currentTrial += 1
            generateStimulus()
        }
    }
    
    private func finishExercise() {
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
                print("Failed to save session: \(error)")
            }
        }
        
        DispatchQueue.main.async {
            self.completedResult = result
        }
    }
}

#Preview {
    StroopExerciseView()
        .environment(ActiveSessionManager())
}
