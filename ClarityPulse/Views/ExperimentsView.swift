import SwiftUI
import SwiftData

struct ExperimentsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var trials: [MicroTrial]
    @Query var exerciseResults: [ExerciseResult]
    
    @State private var showingNewTrialSheet = false
    @State private var showingInsights = false
    @State private var insightMessage = ""
    
    // Form state
    @State private var newTitle = ""
    @State private var newTagA = ""
    @State private var newTagB = ""
    
    // Possible tags to select
    private let availableTags = [
        "Just Woke Up", "Mid-Day Slump", "Late Night", "Sleep Deprived",
        "Fasted", "Post-Meal", "Hydrated", "Dehydrated",
        "Caffeinated", "Nicotine", "Unstimulated",
        "Post-Workout", "High Stress"
    ]
    
    var activeTrial: MicroTrial? {
        trials.first(where: { $0.isActive })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let trial = activeTrial {
                            activeTrialCard(trial)
                        } else {
                            noActiveTrialCard
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Micro-Trials")
            .sheet(isPresented: $showingNewTrialSheet) {
                newTrialSheet
            }
            .alert("Trial Insights", isPresented: $showingInsights) {
                Button("Done", role: .cancel) {
                    if let trial = activeTrial {
                        trial.isActive = false
                    }
                }
            } message: {
                Text(insightMessage)
            }
        }
    }
    
    private var noActiveTrialCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "flask")
                .font(.system(size: 48))
                .foregroundColor(.primary)
                .padding(.bottom, 8)
            
            Text("No Active Trial")
                .font(.title2)
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Run a 7-day A/B test to discover what actually improves your cognitive performance.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                
            VStack(alignment: .leading, spacing: 12) {
                Text("How it Works")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom, 4)
                
                HStack(alignment: .top) {
                    Image(systemName: "1.circle.fill").foregroundColor(.accentColor)
                    Text("Tag your daily state (e.g., Fasted vs. Fed).").font(.subheadline).foregroundColor(.secondary)
                }
                HStack(alignment: .top) {
                    Image(systemName: "2.circle.fill").foregroundColor(.accentColor)
                    Text("Play your daily sessions for 7 days.").font(.subheadline).foregroundColor(.secondary)
                }
                HStack(alignment: .top) {
                    Image(systemName: "3.circle.fill").foregroundColor(.accentColor)
                    Text("Discover which state maximizes your cognitive speed and accuracy.").font(.subheadline).foregroundColor(.secondary)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                newTitle = ""
                newTagA = ""
                newTagB = ""
                showingNewTrialSheet = true
            }) {
                Text("Start New Trial")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(.teal)
            .padding(.top, 12)
        }
        .padding(24)
        .background(.regularMaterial)
        .cornerRadius(24)
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
        .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func activeTrialCard(_ trial: MicroTrial) -> some View {
        let elapsedDays = Calendar.current.dateComponents([.day], from: trial.startDate, to: Date()).day ?? 0
        
        return VStack(spacing: 20) {
            HStack {
                Text(trial.title)
                    .font(.headline)
                    .foregroundColor(Color.primary)
                Spacer()
                Text("Active")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tag A")
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                    Text(trial.tagA)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                }
                
                Spacer()
                
                Text("vs")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Tag B")
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                    Text(trial.tagB)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
            
            VStack(spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                    Spacer()
                    Text("Day \(min(elapsedDays + 1, 7)) of 7")
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundColor(Color.secondary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.primary)
                            .frame(width: min(CGFloat(elapsedDays) / 7.0, 1.0) * geometry.size.width, height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            if elapsedDays >= 7 {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    insightMessage = generateInsights(for: trial)
                    showingInsights = true
                }) {
                    Text("View Insights")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
            } else {
                Text("Insights unlock after 7 days")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                    .padding(.top, 8)
            }
        }
        .padding(24)
        .background(.regularMaterial)
        .cornerRadius(24)
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
        .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var newTrialSheet: some View {
        NavigationStack {
            Form {
                Section("Trial Setup") {
                    TextField("Trial Title (e.g. Coffee vs Water)", text: $newTitle)
                    
                    Picker("Tag A", selection: $newTagA) {
                        Text("Select Tag").tag("")
                        ForEach(availableTags, id: \.self) { tag in
                            Text(tag).tag(tag)
                        }
                    }
                    
                    Picker("Tag B", selection: $newTagB) {
                        Text("Select Tag").tag("")
                        ForEach(availableTags, id: \.self) { tag in
                            Text(tag).tag(tag)
                        }
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: newTagA)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: newTagB)
            .navigationTitle("New Micro-Trial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showingNewTrialSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        let trial = MicroTrial(title: newTitle, tagA: newTagA, tagB: newTagB, startDate: Date(), isActive: true)
                        modelContext.insert(trial)
                        showingNewTrialSheet = false
                    }
                    .disabled(newTitle.isEmpty || newTagA.isEmpty || newTagB.isEmpty || newTagA == newTagB)
                }
            }
        }
    }
    
    private func generateInsights(for trial: MicroTrial) -> String {
        let relevantSessions = exerciseResults.filter { ($0.session?.date ?? Date.distantPast) >= trial.startDate && ($0.session?.date ?? Date.distantPast) <= Date() }
        
        let sessionsA = relevantSessions.filter { $0.tags?.contains(trial.tagA) ?? false }
        let sessionsB = relevantSessions.filter { $0.tags?.contains(trial.tagB) ?? false }
        
        guard !sessionsA.isEmpty, !sessionsB.isEmpty else {
            return "Not enough data collected for both tags to generate insights. Trial concluded."
        }
        
        let avgRTA = sessionsA.map(\.averageReactionTimeMS).reduce(0, +) / Double(sessionsA.count)
        let avgRTB = sessionsB.map(\.averageReactionTimeMS).reduce(0, +) / Double(sessionsB.count)
        
        let winner = avgRTA < avgRTB ? trial.tagA : trial.tagB
        let loser = avgRTA < avgRTB ? trial.tagB : trial.tagA
        
        let diffPercent = (abs(avgRTA - avgRTB) / max(avgRTA, avgRTB)) * 100.0
        
        return "You processed \(String(format: "%.1f", diffPercent))% faster when \(winner) compared to \(loser)."
    }
}

#Preview {
    ExperimentsView()
}
