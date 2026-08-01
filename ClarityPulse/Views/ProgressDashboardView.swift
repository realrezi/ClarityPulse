import SwiftUI
import SwiftData
import Charts
import StoreKit

struct ProgressDashboardView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("totalSessionsCompleted") private var totalSessionsCompleted: Int = 0
    @AppStorage("hasRequestedReview") private var hasRequestedReview: Bool = false
    
    @Query private var results: [ExerciseResult]
    
    private var sortedResults: [ExerciseResult] {
        results.sorted { ($0.session?.date ?? Date.distantPast) > ($1.session?.date ?? Date.distantPast) }
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Your Cognitive Journey")
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)
                        .minimumScaleFactor(0.8)
                        .accessibilityAddTraits(.isHeader)
                    
                    if results.isEmpty {
                        Spacer()
                        Text("Complete some exercises to see your progress here.")
                            .font(.body)
                            .foregroundColor(Color.primary)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else {
                        ConsistencyHeatmapView(results: results)
                        
                        Divider()
                            .padding(.vertical)
                        
                        VStack(spacing: 8) {
                            Text("Cognitive Archetype")
                                .font(.headline)
                                .fontDesign(.rounded)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                                .accessibilityAddTraits(.isHeader)
                            
                            VStack {
                                if let archetype = ArchetypeEngine.calculate(results: results) {
                                    VStack(spacing: 12) {
                                        Image(systemName: archetype.icon)
                                            .font(.system(size: 40))
                                            .foregroundColor(.accentColor)
                                        Text(archetype.title)
                                            .font(.system(.title2, design: .rounded).weight(.heavy))
                                            .foregroundColor(.primary)
                                        Text(archetype.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                } else {
                                    Text("Complete 5 Stroop sessions to unlock your Cognitive Archetype.")
                                        .font(.subheadline)
                                        .italic()
                                        .foregroundColor(Color.primary.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                            .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.vertical)
                            
                        let chartData = extractChartData()
                        
                        VStack(spacing: 8) {
                            Text("Cognitive Footprint")
                                .font(.headline)
                                .fontDesign(.rounded)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                                .accessibilityAddTraits(.isHeader)
                                
                            Text("A larger, more expanded shape indicates stronger overall cognitive fitness and processing speed.")
                                .font(.footnote)
                                .foregroundColor(Color.primary.opacity(0.8))
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                            
                            RadarChartView(
                                nBackAccuracy: nBackAccuracyValue,
                                nBackLevel: nBackLevelValue,
                                stroopAccuracy: stroopAccuracyValue,
                                stroopRT: stroopRTValue
                            )
                            .frame(height: 250)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                            .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        VStack(spacing: 8) {
                            Chart(chartData, id: \.date) { dataPoint in
                                LineMark(
                                    x: .value("Date", dataPoint.date),
                                    y: .value("Reaction Time (ms)", dataPoint.reactionTime)
                                )
                                .foregroundStyle(Color.primary)
                                
                                PointMark(
                                    x: .value("Date", dataPoint.date),
                                    y: .value("Reaction Time (ms)", dataPoint.reactionTime)
                                )
                                .foregroundStyle(.teal)
                            }
                            .frame(height: 300)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                            .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                            .accessibilityLabel("Line chart showing your reaction time improvements over recent sessions. Lower is better.")
                            
                            Text("Lower reaction time means faster cognitive processing.")
                                .font(.footnote)
                                .foregroundColor(Color.primary.opacity(0.8))
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        VStack(spacing: 8) {
                            Text("Speed-Accuracy Tradeoff")
                                .font(.headline)
                                .fontDesign(.rounded)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                                .accessibilityAddTraits(.isHeader)
                            
                            Text("Optimal cognitive zone is clustering in the top-left (fast and accurate).")
                                .font(.footnote)
                                .foregroundColor(Color.primary.opacity(0.8))
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                            
                            Chart(chartData, id: \.date) { dataPoint in
                                PointMark(
                                    x: .value("Reaction Time", dataPoint.reactionTime),
                                    y: .value("Accuracy", dataPoint.accuracy)
                                )
                                .foregroundStyle(Color.primary)
                            }
                            .chartXAxisLabel("Reaction Time (ms)")
                            .chartYAxisLabel("Accuracy (%)")
                            .frame(height: 300)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                            .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                            .accessibilityLabel("Scatter plot showing speed-accuracy tradeoff. Reaction time on X-axis and Accuracy on Y-axis.")
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        VStack(spacing: 8) {
                            Text("Recent Sessions")
                                .font(.headline)
                                .fontDesign(.rounded)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                                .accessibilityAddTraits(.isHeader)
                            
                            ForEach(sortedResults.prefix(10)) { result in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text((result.session?.date ?? Date()).formatted(date: .abbreviated, time: .shortened))
                                            .font(.subheadline)
                                            .foregroundColor(Color.primary.opacity(0.8))
                                        Spacer()
                                        Text(result.exerciseType)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.primary)
                                    }
                                    
                                    HStack {
                                        Text("Accuracy: \(Int(result.accuracyPercentage))%")
                                            .font(.caption)
                                            .monospacedDigit()
                                            .foregroundColor(Color.primary)
                                        Spacer()
                                        Text("Speed: \(Int(result.averageReactionTimeMS)) ms")
                                            .font(.caption)
                                            .monospacedDigit()
                                            .foregroundColor(Color.primary)
                                    }
                                    
                                    if result.exerciseType == "Stroop" && result.averageReactionTimeMS > 0 {
                                        Text(stroopBenchmarkText(for: result.averageReactionTimeMS))
                                            .font(.caption2)
                                            .italic()
                                            .foregroundColor(Color.primary.opacity(0.7))
                                    }
                                    
                                    if let tags = result.tags, !tags.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(tags, id: \.self) { tag in
                                                    Text(tag)
                                                        .font(.system(size: 10, weight: .semibold))
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(Color.primary.opacity(0.15))
                                                        .foregroundColor(Color.primary)
                                                        .cornerRadius(8)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(.regularMaterial)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                                .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            checkAndRequestReview()
        }
    }
    
    private struct ChartDataPoint {
        let date: Date
        let reactionTime: Double
        let accuracy: Double
    }
    
    private func extractChartData() -> [ChartDataPoint] {
        sortedResults.reversed().compactMap { result in
            guard let date = result.session?.date else { return nil }
            return ChartDataPoint(date: date, reactionTime: result.averageReactionTimeMS, accuracy: result.accuracyPercentage)
        }
    }
    
    private var nBackAccuracyValue: Double {
        let nBackResults = results.filter { $0.exerciseType.contains("Back") }
        guard !nBackResults.isEmpty else { return 0.0 }
        let avg = nBackResults.map { $0.accuracyPercentage }.reduce(0, +) / Double(nBackResults.count)
        return avg / 100.0
    }
    
    private var nBackLevelValue: Double {
        let nBackResults = results.filter { $0.exerciseType.contains("Back") }
        guard !nBackResults.isEmpty else { return 0.0 }
        let levels = nBackResults.compactMap { result -> Double? in
            guard let firstChar = result.exerciseType.first, let level = Double(String(firstChar)) else { return nil }
            return level
        }
        let avg = levels.reduce(0, +) / Double(max(1, levels.count))
        return avg / 5.0
    }
    
    private var stroopAccuracyValue: Double {
        let stroopResults = results.filter { $0.exerciseType == "Stroop" }
        guard !stroopResults.isEmpty else { return 0.0 }
        let avg = stroopResults.map { $0.accuracyPercentage }.reduce(0, +) / Double(stroopResults.count)
        return avg / 100.0
    }
    
    private var stroopRTValue: Double {
        let stroopResults = results.filter { $0.exerciseType == "Stroop" }
        guard !stroopResults.isEmpty else { return 0.0 }
        let avg = stroopResults.map { $0.averageReactionTimeMS }.reduce(0, +) / Double(stroopResults.count)
        if avg == 0 { return 0.0 }
        let maxRT = 1500.0
        return max(0, 1.0 - (avg / maxRT))
    }
    
    private func stroopBenchmarkText(for rt: Double) -> String {
        if rt == 0 { return "" }
        if rt < 400 { return "Elite / Fighter Pilot tier" }
        if rt <= 600 { return "High Cognitive Sharpness" }
        if rt <= 900 { return "Standard Baseline" }
        return "Fatigued / Slower Processing"
    }
    
    private func checkAndRequestReview() {
        if totalSessionsCompleted >= 5 && !hasRequestedReview {
            requestReview()
            hasRequestedReview = true
        }
    }
}

#Preview {
    ProgressDashboardView()
}
