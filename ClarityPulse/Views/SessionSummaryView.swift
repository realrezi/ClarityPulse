import SwiftUI
import SwiftData

struct SessionSummaryView: View {
    let result: ExerciseResult
    let correctMatches: Int
    let onDone: () -> Void
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("\(result.exerciseType) Complete")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                    .accessibilityAddTraits(.isHeader)
                
                VStack(spacing: 24) {
                    summaryCard(title: "Accuracy", value: String(format: "%.1f%%", result.accuracyPercentage), icon: "target")
                    summaryCard(title: "Correct Matches", value: "\(correctMatches)", icon: "checkmark.circle.fill")
                    summaryCard(title: "Reaction Time", value: String(format: "%.0f ms", result.averageReactionTimeMS), icon: "bolt.fill")
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onDone()
                }) {
                    Text("Done")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
                .cornerRadius(16)
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
                .foregroundColor(Color.primary)
                .frame(width: 32)
            
            Text(title)
                .font(.headline)
                .foregroundColor(Color.primary)
            
            Spacer()
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()
                .foregroundColor(Color.primary)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
        .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    SessionSummaryView(
        result: ExerciseResult(exerciseType: "2-Back", accuracyPercentage: 85.5, averageReactionTimeMS: 450.0),
        correctMatches: 12,
        onDone: {}
    )
}
